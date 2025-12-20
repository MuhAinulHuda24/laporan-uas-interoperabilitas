== Konsep Normalisasi Data

Normalisasi data adalah proses mengkonversi dan menyeragamkan data dari berbagai sumber yang memiliki format, struktur, dan tipe data berbeda ke dalam satu format unified yang telah ditentukan. Dalam konteks proyek Banyuwangi Marketplace, normalisasi adalah langkah kritis yang memungkinkan data dari tiga vendor dengan karakteristik unik yang berbeda untuk dapat digabungkan dan ditampilkan dalam satu dashboard terpusat.

Setiap vendor dalam proyek ini memiliki keunikan: Vendor A menggunakan konvensi lokal dengan tipe data string, Vendor B menggunakan standar modern dengan camelCase dan tipe data proper, dan Vendor C menggunakan struktur nested dengan sistem pajak terpisah. Tanpa normalisasi, data-data ini tidak dapat diintegrasikan dengan baik karena perbedaan fundamental dalam penamaan field, tipe data, dan struktur organisasi data.

Lead Integrator bertanggung jawab merancang dan mengimplementasikan proses normalisasi yang robust dan efisien. Proses ini bukan hanya tentang mapping field names, tetapi juga konversi tipe data, validasi data, dan penerapan logika bisnis spesifik untuk memastikan semua data yang masuk ke marketplace memiliki kualitas tinggi dan format yang konsisten.

== Unified Schema Marketplace

Unified schema adalah struktur data yang telah disepakati sebagai standar untuk menyimpan data produk dalam marketplace terpusat. Schema ini dirancang untuk mengakomodasi karakteristik dari ketiga vendor sambil mempertahankan simplicity dan consistency. Berikut adalah field-field dalam unified schema:

#table(
  columns: (2.5cm, 2cm, 4.5cm),
  [*Field*], [*Tipe Data*], [*Deskripsi*],
  [`id`], [String], [Identifikasi unik produk dengan prefix vendor (A, B, C) untuk membedakan sumber],
  [`nama`], [String], [Nama produk yang sudah dinormalisasi dan dideskripsikan dengan jelas],
  [`harga_final`], [Number], [Harga akhir dalam rupiah setelah semua perhitungan (diskon, pajak) selesai],
  [`status`], [String], [Status ketersediaan produk, bernilai "Tersedia" atau "Tidak Tersedia"],
  [`sumber`], [String], [Identifikasi vendor sumber data, bernilai "Vendor A", "Vendor B", atau "Vendor C"],
)

Struktur unified schema dirancang dengan prinsip simplicity dan universality. Setiap field memiliki makna yang jelas dan dapat menampung data dari ketiga vendor meskipun memiliki struktur asal yang berbeda. Field `id` dilengkapi dengan prefix untuk memudahkan tracking sumber data. Field `nama` sudah melalui standardisasi dan enrichment (penambahan informasi), seperti penambahan suffix "(Recommended)" untuk produk Vendor C. Field `harga_final` menyimpan hasil akhir dari semua kalkulasi, dan field `status` sudah dikonversi ke format string yang seragam.

*Mapping Field dari Setiap Vendor ke Unified Schema:*

#table(
  columns: (2.5cm, 2.5cm, 2.5cm, 2.5cm),
  [*Vendor A Field*], [*Vendor B Field*], [*Vendor C Field*], [*Unified Field*],
  [`kd_produk`], [`sku`], [`id` + prefix], [`id`],
  [`nm_brg`], [`productName`], [`details.name`], [`nama`],
  [`hrg` × 0.9], [`price`], [`pricing.base_price + tax`], [`harga_final`],
  [`ket_stok`], [`isAvailable`], [`stock > 0`], [`status`],
  [—], [—], [—], [`sumber`],
)

Tabel mapping di atas menunjukkan bagaimana setiap field dari vendor yang berbeda dipetakan ke unified schema. Perhatikan bahwa field `sumber` tidak ada di vendor manapun dan ditambahkan oleh Lead Integrator untuk tracking purposes. Perhitungan `harga_final` berbeda untuk setiap vendor tergantung logika bisnis masing-masing.

== Algoritma Integrasi Data

Proses integrasi data mengikuti alur step-by-step yang terstruktur. Berikut adalah algoritma lengkap yang diimplementasikan di `integratorController.js`:

*Step 1: Ambil Data dari API Setiap Vendor*

Lead Integrator melakukan fetch data secara parallel dari ketiga endpoint vendor API menggunakan `Promise.all()`. Penggunaan parallel fetching ini meningkatkan performance karena tidak perlu menunggu satu vendor selesai sebelum fetch vendor lain. Request dilakukan ke:
- `http://localhost:3000/api/vendor-a` untuk Vendor A
- `http://localhost:3000/api/vendor-b` untuk Vendor B
- `http://localhost:3000/api/vendor-c` untuk Vendor C

*Step 2: Mapping Field sesuai Unified Schema*

Setelah data diterima, Lead Integrator melakukan mapping field menggunakan method `.map()` untuk setiap array data. Mapping ini melakukan ekstraksi field dari vendor dan menempatkannya ke field unified schema yang sesuai. Untuk Vendor C yang memiliki nested objects, proses ini melibatkan akses ke property nested seperti `item.details.name` dan `item.pricing.base_price`.

*Step 3: Konversi Tipe Data Jika Diperlukan*

Konversi tipe data dilakukan sesuai dengan karakteristik masing-masing vendor:
- *Vendor A*: Konversi `hrg` dari String ke Number menggunakan `parseInt()`
- *Vendor B*: Field `price` sudah Number, tidak perlu konversi
- *Vendor C*: Akses nested property dan penjumlahan `base_price + tax`

*Step 4: Terapkan Logika Bisnis*

Logika bisnis spesifik diterapkan pada tahap ini:
- *Vendor A*: Kalkulasi diskon 10% pada harga (harga × 0.9)
- *Vendor B*: Gunakan harga apa adanya tanpa modifikasi
- *Vendor C*: Jumlahkan base_price dan tax, kemudian identifikasi dengan suffix "(Recommended)"

*Step 5: Konversi Status Stok ke Format Seragam*

Status ketersediaan dari ketiga vendor dikonversi ke format String yang seragam:
- *Vendor A*: Kondisi `ket_stok == "ada"` → `"Tersedia"`, selainnya → `"Tidak Tersedia"`
- *Vendor B*: Kondisi `isAvailable == true` → `"Tersedia"`, `false` → `"Tidak Tersedia"`
- *Vendor C*: Kondisi `stock > 0` → `"Tersedia"`, `stock == 0` → `"Tidak Tersedia"`

*Step 6: Gabungkan Data dari Ketiga Vendor*

Setelah normalisasi setiap vendor selesai, Lead Integrator menggabungkan ketiga array data menggunakan spread operator:

```javascript
const resultIntegrator = [...normalizedDataA, ...normalizedDataB, ...normalizedDataC];
```

Hasil gabungan ini adalah dataset terpadu yang siap dikirimkan ke dashboard marketplace dengan format yang seragam.

== Penanganan Error dan Validasi

Penanganan error dan validasi adalah komponen kritis untuk memastikan integritas data dalam marketplace. Proses validasi dilakukan pada beberapa tahap:

*Validasi pada Tahap Fetch Data*

Proses fetch data dari API vendor dibungkus dalam try-catch block untuk menangani error koneksi atau response error dari vendor. Jika salah satu vendor gagal merespon, seluruh proses integrasi akan ditangani dengan error handler yang mengembalikan status 500 dan pesan error yang informatif.

```javascript
try {
    const [resA, resB, resC] = await Promise.all([
        axios.get(`http://localhost:3000/api/vendor-a`),
        axios.get(`http://localhost:3000/api/vendor-b`),
        axios.get(`http://localhost:3000/api/vendor-c`),
    ]);
    // ... rest of normalization process
} catch (error) {
    console.error(error.message);
    res.status(500).json({
        message: "Error saat mengambil api vendor",
    });
}
```

*Validasi Tipe Data*

Sebelum melakukan kalkulasi matematika, Lead Integrator memastikan bahwa nilai-nilai numerik adalah tipe Number yang valid. Penggunaan `parseInt()` untuk Vendor A memastikan konversi dari String ke Number yang aman.

*Validasi Nilai Harga*

Harga final harus selalu positif dan bukan null. Jika ada kalkulasi yang menghasilkan harga negatif atau undefined, data tersebut harus ditolak atau ditangani dengan default value.

*Validasi Nama Produk*

Nama produk tidak boleh kosong atau undefined. Untuk Vendor C, penambahan suffix "(Recommended)" hanya dilakukan jika nama produk tidak kosong.

*Validasi Status Ketersediaan*

Konversi status ketersediaan harus menghasilkan salah satu dari dua nilai yang diizinkan: "Tersedia" atau "Tidak Tersedia". Tidak boleh ada status dengan nilai lain.

*Validasi Sumber Data*

Field `sumber` harus selalu diisi dengan nama vendor yang benar untuk memastikan traceability. Jika proses normalisasi gagal untuk vendor tertentu, data dari vendor tersebut harus tidak masuk ke hasil akhir.

== Hasil Akhir Integrasi

Berikut adalah contoh hasil akhir setelah integrasi data dari ketiga vendor dalam format unified schema:

```json
[
  {
    "id": "A001",
    "nama": "Kopi Bubuk 100g",
    "harga_final": 13500,
    "status": "Tersedia",
    "sumber": "Vendor A"
  },
  {
    "id": "A002",
    "nama": "Kripik Singkong 200g",
    "harga_final": 9000,
    "status": "Tersedia",
    "sumber": "Vendor A"
  },
  {
    "id": "TSHIRT-001",
    "nama": "Kaos Ijen Crater",
    "harga_final": 75000,
    "status": "Tersedia",
    "sumber": "Vendor B"
  },
  {
    "id": "MUG-002",
    "nama": "Mug Banyuwangi",
    "harga_final": 45000,
    "status": "Tersedia",
    "sumber": "Vendor B"
  },
  {
    "id": "A501",
    "nama": "Nasi Tempong (Recommended)",
    "harga_final": 22000,
    "status": "Tersedia",
    "sumber": "Vendor C"
  },
  {
    "id": "A502",
    "nama": "Lumpia Goreng (Recommended)",
    "harga_final": 16500,
    "status": "Tersedia",
    "sumber": "Vendor C"
  },
  {
    "id": "A506",
    "nama": "Martabak Telur (Recommended)",
    "harga_final": 27500,
    "status": "Tersedia",
    "sumber": "Vendor C"
  }
]
```

*Analisis Hasil Integrasi:*

Hasil akhir integrasi di atas menunjukkan data dari ketiga vendor yang telah berhasil dinormalisasi ke dalam unified schema. Perhatikan beberapa poin penting:

1. *Konsistensi Format ID*: ID dari Vendor A dimulai dengan "A" (A001, A002, A501, dst), sementara Vendor B menggunakan SKU original (TSHIRT-001, MUG-002). Prefix memudahkan identifikasi sumber data.

2. *Harga Final Terhitung Dengan Benar*: Kopi Bubuk dari Vendor A awalnya 15000, setelah diskon 10% menjadi 13500. Nasi Tempong dari Vendor C dengan base_price 20000 dan tax 2000 menjadi 22000. Kaos dan Mug dari Vendor B tetap sesuai price original.

3. *Status Ketersediaan Seragam*: Semua item dalam hasil menunjukkan status "Tersedia" atau "Tidak Tersedia" dalam format String yang konsisten, tidak ada variasi seperti "ada", "habis", true, false, atau nilai stock.

4. *Penambahan Suffix untuk Vendor C*: Semua produk dari Vendor C ditambahkan dengan suffix "(Recommended)" untuk membedakan positioning mereka sebagai rekomendasi khusus.

5. *Tracking Sumber Data*: Field `sumber` memudahkan Lead Integrator dan user dashboard untuk melacak asal setiap produk, mendukung transparansi dalam sistem integrasi.

Dataset terintegrasi ini siap ditampilkan di dashboard marketplace terpusat dan dapat digunakan untuk analisis, filtering, dan reporting yang lebih lanjut. Proses normalisasi dan integrasi yang robust memastikan bahwa meskipun ketiga vendor memiliki karakteristik unik, data mereka dapat bersatu dalam satu platform yang kohesif dan mudah digunakan.