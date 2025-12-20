== Latar Belakang Vendor B

Vendor B, yang bernama DistroModern, merupakan sistem aplikasi kasir modern yang telah menerapkan standar penamaan dan praktik terbaik internasional. Berbeda dengan Vendor A (WarungLegacy) yang masih menggunakan konvensi lokal dan tipe data primitif, DistroModern sudah dirancang dengan arsitektur yang matang dan mengikuti best practices pengembangan perangkat lunak modern.

Sistem ini dikembangkan dengan filosofi "API-first" yang mengutamakan konsistensi data dan penamaan yang seragam. Setiap field dalam respons API telah ditentukan dengan jelas menggunakan naming convention internasional dan tipe data yang sesuai dengan standar JSON. Hal ini membuat proses integrasi dengan dashboard terpusat menjadi jauh lebih efisien karena tidak memerlukan konversi tipe data yang kompleks.

Sebagai Lead Integrator, menangani Vendor B dianggap pekerjaan yang lebih straightforward dibandingkan Vendor A. Kami hanya perlu melakukan pemetaan field names dan validasi format, tanpa perlu melakukan transformasi tipe data yang rumit.

== Karakteristik Sistem Vendor B

Sistem Vendor B memiliki beberapa karakteristik teknis yang membedakannya dari vendor lain:

*1. Penamaan Field dalam Bahasa Inggris dengan camelCase*

Vendor B menggunakan konvensi penamaan camelCase untuk semua field yang diekspos dalam API. Contohnya adalah `sku`, `productName`, `price`, dan `isAvailable`. Standar ini memudahkan integrasi dengan sistem berbasis JavaScript dan framework modern lainnya. Tidak ada inconsistency dalam penamaan field, sehingga mapping dapat dilakukan secara konsisten.

*2. Tipe Data yang Sesuai dengan Standar JSON*

Berbeda dengan Vendor A yang menggunakan tipe data string untuk semua field, Vendor B sudah menerapkan tipe data yang sesuai:
- Field `price` berupa tipe numerik (Number), bukan string
- Field `isAvailable` berupa tipe boolean (true/false), bukan string
- Field `productName` dan `sku` berupa tipe string

Penggunaan tipe data yang tepat ini memastikan bahwa operasi numerik atau logika boolean dapat langsung dilakukan tanpa konversi tambahan.

*3. Struktur Data Flat dan Sederhana*

Respons API Vendor B menggunakan struktur data yang flat dengan hanya 4 field utama. Tidak ada nested object atau array yang kompleks seperti pada Vendor C. Struktur sederhana ini memudahkan parsing dan memproses data di sisi client.

*4. Tidak Memerlukan Transformasi Kompleks*

Karena tipe data sudah proper dan konsisten, Vendor B tidak memerlukan transformasi tipe data kompleks pada tahap normalisasi. Lead Integrator cukup melakukan pemetaan field names ke schema marketplace terpusat tanpa perlu operasi kalkulasi atau konversi tipe.

== Perbedaan dengan Vendor A

Perbedaan mendasar antara Vendor A (WarungLegacy) dan Vendor B (DistroModern) dapat dilihat pada tabel berikut:

#table(
  columns: (2.5cm, 3cm, 3cm),
  [*Aspek*], [*Vendor A (Legacy)*], [*Vendor B (Modern)*],
  [Naming Convention], [Bahasa Indonesia, snake_case\n(kd_produk, nm_brg, hrg)], [Bahasa Inggris, camelCase\n(sku, productName, price)],
  [Tipe Data], [Semua tipe string\n(hrg: "15000", ket_stok: "ada")], [Tipe data proper\n(price: 75000, isAvailable: true)],
  [Jumlah Field], [4 field sederhana], [4 field sederhana],
  [Kompleksitas Struktur], [Flat, homogenous], [Flat, heterogenous type],
  [Proses Normalisasi], [Konversi tipe data, mapping, diskon kalkulasi], [Hanya mapping field names, validasi],
  [Kesiapan Integrasi], [Memerlukan transformasi signifikan], [Minimal transformation required],
)

Dari tabel di atas, dapat disimpulkan bahwa Vendor B memiliki tingkat kesiapan yang jauh lebih baik untuk integrasi dengan sistem terpusat dibandingkan Vendor A.

== Proses Normalisasi Vendor B

Proses normalisasi untuk data dari Vendor B jauh lebih sederhana dibandingkan Vendor A. Berikut adalah tahap-tahap normalisasi yang dilakukan oleh Lead Integrator:

*Tahap 1: Pemetaan Field Names*

Field dari Vendor B dipetakan ke schema marketplace terpusat dengan konvensi naming yang telah disepakati. Pemetaan ini bersifat one-to-one dan tidak memerlukan logika kondisional:

- `sku` → `id`
- `productName` → `nama`
- `price` → `harga_final`
- `isAvailable` → `status` (dengan transformasi nilai boolean ke string untuk konsistensi)

*Tahap 2: Validasi Format SKU*

Lead Integrator melakukan validasi bahwa SKU dari Vendor B mengikuti format yang konsisten. Dalam kasus DistroModern, format SKU adalah `[KATEGORI]-[NOMOR]` seperti `TSHIRT-001`, `MUG-002`, dst. Validasi ini memastikan tidak ada data dengan format SKU yang anomali.

*Tahap 3: Cek Konsistensi Nilai Boolean*

Karena Vendor B sudah menggunakan tipe data boolean untuk field `isAvailable`, Lead Integrator hanya perlu memastikan bahwa nilai-nilai yang diterima adalah boolean murni (true atau false) tanpa ada string yang menyerupai boolean.

*Tahap 4: Tidak Ada Kalkulasi Diskon*

Berbeda dengan Vendor A yang menerapkan diskon 10% pada harga akhir, Vendor B menyediakan harga yang sudah final. Lead Integrator tidak perlu melakukan kalkulasi diskon tambahan, sehingga proses normalisasi menjadi lebih cepat.

Berikut adalah snippet kode dari `integratorController.js` yang menunjukkan proses normalisasi Vendor B:

```javascript
const normalizedDataB = dataB.map(item => {
    const price = parseInt(item.price);
    let statusStok = "Tidak Tersedia";
    if(item.isAvailable) {
        statusStok = "Tersedia";
    }

    return {
        id:  item.sku,
        nama: item.productName,
        harga_final: price,
        status: statusStok,
        sumber: "Vendor B"
    };
});
```

Proses normalisasi Vendor B mencerminkan filosofi sistem yang modern dan terstruktur dengan baik.

== Contoh Respons API Vendor B

Berikut adalah contoh respons lengkap dari endpoint `/api/vendor-b` yang menunjukkan produk-produk dari DistroModern:

```json
[
  {
    "sku": "TSHIRT-001",
    "productName": "Kaos Ijen Crater",
    "price": 75000,
    "isAvailable": true
  },
  {
    "sku": "MUG-002",
    "productName": "Mug Banyuwangi",
    "price": 45000,
    "isAvailable": true
  },
  {
    "sku": "SOUV-003",
    "productName": "Souvenir Khas Banyuwangi",
    "price": 25000,
    "isAvailable": true
  },
  {
    "sku": "BAG-004",
    "productName": "Tas Krama Banyuwangi",
    "price": 120000,
    "isAvailable": false
  }
]
```

*Penjelasan Struktur Data:*

Respons API di atas terdiri dari array dengan 4 produk yang diproduksi oleh DistroModern. Setiap produk memiliki struktur yang konsisten dengan 4 field:

- *sku* (String): Kode unik produk dalam format kategori-nomor. Contoh: "TSHIRT-001" menunjukkan produk kategori T-Shirt dengan nomor 001.
- *productName* (String): Nama produk dalam bahasa Indonesia yang deskriptif. Semua produk merupakan merchandise khas Banyuwangi seperti kaos, mug, dan tas.
- *price* (Number): Harga produk dalam rupiah. Nilai ini sudah final dan tidak ada diskon tambahan. Kisaran harga berkisar dari Rp 25.000 hingga Rp 120.000.
- *isAvailable* (Boolean): Status ketersediaan produk. Nilai `true` berarti produk tersedia, dan `false` berarti out-of-stock. Dalam contoh ini, 3 dari 4 produk tersedia, sedangkan produk BAG-004 sedang tidak tersedia.

*Keunggulan Format Vendor B:*

Respons API dari Vendor B menunjukkan beberapa keunggulan teknis. Pertama, tipe data sudah sesuai dengan JSON standard, sehingga tidak perlu konversi manual. Kedua, struktur data yang flat membuat parsing menjadi efficient. Ketiga, konsistensi dalam penamaan field dan format data memudahkan Lead Integrator untuk melakukan pemetaan dan validasi data tanpa logika kondisional yang kompleks. Keempat, response time diharapkan lebih cepat karena tidak ada nested object yang perlu di-traverse.