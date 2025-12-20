== Latar Belakang Vendor C

Vendor C merupakan sistem Point of Sale (POS) yang digunakan oleh restoran dan warung kuliner di wilayah Banyuwangi. Karakteristik utama dari usaha restoran/warung kuliner ini adalah beragamnya menu yang ditawarkan, mulai dari makanan berat hingga minuman, dengan sistem pricing yang mencakup pajak untuk setiap item. Vendor C menangani menu makanan dan minuman lokal Banyuwangi yang kaya ragam, seperti Nasi Tempong, Soto Ayam, Lumpia Goreng, dan berbagai minuman tradisional.

Sistem POS Vendor C dirancang untuk mengelola inventori dengan struktur data yang lebih kompleks dibandingkan vendor retail lainnya. Setiap produk menu dilengkapi dengan kategori (Food atau Beverage), harga dasar, dan pajak yang dihitung secara terpisah. Kompleksitas ini mencerminkan kebutuhan bisnis restoran yang harus mengelola berbagai kategori produk dengan perhitungan harga yang lebih sophisticated.

Dari perspektif integrasi data, Vendor C menjadi tantangan tersendiri bagi Lead Integrator karena struktur data yang nested dan logika bisnis yang lebih kompleks. Normalisasi data dari Vendor C memerlukan pemahaman mendalam tentang format JSON bersarang (nested objects) dan operasi kalkulasi harga yang melibatkan pembubuhan pajak.

== Karakteristik Unik Vendor C

Sistem Vendor C memiliki beberapa karakteristik yang membedakannya dari Vendor A dan Vendor B:

*1. Struktur Data Bersarang (Nested Objects)*

Berbeda dengan Vendor A dan B yang menggunakan struktur flat, Vendor C mengorganisir data dalam struktur bersarang yang lebih kompleks. Data produk di-organisir dalam tiga bagian utama: `id` (top-level), `details` (nested object untuk informasi deskriptif), `pricing` (nested object untuk informasi harga), dan `stock` (top-level). Struktur bersarang ini memungkinkan pemisahan logis antara informasi berbeda, tetapi memerlukan traversal yang lebih dalam saat ekstraksi data.

*2. Penamaan Field dalam Bahasa Inggris dengan snake_case*

Vendor C menggunakan konvensi penamaan snake_case untuk field-field dalam nested object, seperti `base_price`, `product_name`, dan `category`. Ini berbeda dari camelCase yang digunakan Vendor B. Meskipun masih dalam bahasa Inggris, konsistensi penamaan convention lebih rendah dibandingkan Vendor B.

*3. Kategori Produk dan Diversifikasi Menu*

Vendor C mengimplementasikan sistem kategorisasi produk dengan field `category` yang dapat berisi nilai seperti "Food" atau "Beverage". Ini mencerminkan karakteristik bisnis restoran yang menawarkan menu beragam. Kategorisasi ini memberikan dimensi tambahan untuk analisis dan filtering data di dashboard terpusat.

*4. Sistem Pajak Terpisah dalam Pricing*

Setiap produk dari Vendor C memiliki dua komponen harga: `base_price` (harga dasar) dan `tax` (pajak). Pajak dihitung sebesar 10% dari harga dasar dan disimpan sebagai field terpisah. Ini berbeda dari Vendor A yang menerapkan diskon dan Vendor B yang tidak memiliki perhitungan harga tambahan. Kombinasi base_price dan tax menjadi harga final yang harus dihitung saat normalisasi.

*5. Manajemen Stok Berbasis Quantity*

Vendor C menggunakan field `stock` untuk menyimpan jumlah stok dalam bentuk angka integer. Berbeda dengan Vendor A yang hanya menyimpan status string ("ada" atau "habis"), Vendor C menyimpan angka stok aktual. Lead Integrator perlu melakukan konversi dari quantity number menjadi status string ("Tersedia" jika stock > 0, "Tidak Tersedia" jika stock = 0).

== Struktur Data Vendor C

Skema data dari Vendor C terdiri dari field-field berikut:

#table(
  columns: (2.5cm, 2cm, 4.5cm),
  [*Field*], [*Tipe Data*], [*Penjelasan*],
  [`id`], [Integer], [Identifikasi unik produk menu dalam format angka, dimulai dari 501],
  [`details.name`], [String], [Nama produk menu dalam bahasa Indonesia yang deskriptif],
  [`details.category`], [String], [Kategori produk, bernilai "Food" atau "Beverage"],
  [`pricing.base_price`], [Integer], [Harga dasar produk dalam rupiah sebelum pajak],
  [`pricing.tax`], [Integer], [Jumlah pajak dalam rupiah, dihitung sebesar 10% dari base_price],
  [`stock`], [Integer], [Jumlah stok produk yang tersedia di inventori restoran],
)

Struktur data ini menunjukkan bahwa Vendor C menerapkan normalized design dengan pemisahan concern antara informasi detail produk, pricing, dan inventory. Pemisahan ini membuat data lebih terstruktur namun memerlukan proses ekstraksi yang lebih kompleks.

== Contoh Output JSON Vendor C

Berikut adalah contoh respons lengkap dari endpoint `/api/vendor-c` yang menunjukkan menu-menu restoran dari Vendor C:

```json
[
  {
    "id": 501,
    "details": {
      "name": "Nasi Tempong",
      "category": "Food"
    },
    "pricing": {
      "base_price": 20000,
      "tax": 2000
    },
    "stock": 50
  },
  {
    "id": 502,
    "details": {
      "name": "Lumpia Goreng",
      "category": "Food"
    },
    "pricing": {
      "base_price": 15000,
      "tax": 1500
    },
    "stock": 75
  },
  {
    "id": 503,
    "details": {
      "name": "Soto Ayam",
      "category": "Food"
    },
    "pricing": {
      "base_price": 18000,
      "tax": 1800
    },
    "stock": 60
  },
  {
    "id": 506,
    "details": {
      "name": "Martabak Telur",
      "category": "Food"
    },
    "pricing": {
      "base_price": 25000,
      "tax": 2500
    },
    "stock": 40
  }
]
```

*Penjelasan Struktur Data:*

Respons API Vendor C terdiri dari array dengan 4 produk menu restoran. Setiap produk memiliki struktur bersarang yang kompleks dibandingkan Vendor A dan B. Struktur ini terdiri dari empat bagian utama: `id` untuk identifikasi unik, `details` berisi nama dan kategori produk, `pricing` berisi harga dasar dan pajak, serta `stock` untuk jumlah stok.

Nilai-nilai dalam contoh di atas mencerminkan menu khas restoran di Banyuwangi dengan harga yang kompetitif. Nasi Tempong sebagai hidangan unggulan memiliki harga base Rp 20.000 dengan pajak Rp 2.000, sehingga total harga menjadi Rp 22.000. Martabak Telur sebagai makanan premium memiliki harga tertinggi dengan base Rp 25.000 plus pajak Rp 2.500 menjadi Rp 27.500. Semua produk dalam contoh ini memiliki stok yang tersedia dengan jumlah berkisar dari 40 hingga 75 porsi.

== Proses Normalisasi Vendor C

Proses normalisasi data dari Vendor C melibatkan beberapa tahap yang lebih kompleks dibandingkan Vendor A dan B karena struktur data nested dan logika perhitungan harga:

*Tahap 1: Ekstraksi Data dari Nested Objects*

Lead Integrator harus melakukan traversal mendalam untuk mengakses field-field yang berada dalam struktur nested. Field `name` harus diakses melalui `details.name`, dan field harga harus diakses melalui `pricing.base_price` dan `pricing.tax`. Proses ekstraksi ini memerlukan pemahaman tentang akses nested property dalam JavaScript.

*Tahap 2: Kalkulasi Harga Final*

Harga final dari produk Vendor C adalah penjumlahan antara `base_price` dan `tax`. Misalnya, untuk Nasi Tempong dengan base_price 20000 dan tax 2000, harga final menjadi 22000. Kalkulasi ini dilakukan untuk setiap item tanpa ada modifikasi harga tambahan seperti diskon. Konsistensi dalam kalkulasi harga ini penting untuk memastikan akurasi data di dashboard terpusat.

*Tahap 3: Konversi Status Stok*

Field `stock` dari Vendor C adalah berupa integer (angka), tetapi dashboard marketplace memerlukan status dalam bentuk string. Lead Integrator melakukan konversi dengan logika: jika `stock > 0`, maka status adalah "Tersedia"; jika `stock === 0`, maka status adalah "Tidak Tersedia". Konversi ini memastikan konsistensi format status di seluruh vendor.

*Tahap 4: Penambahan Marker "(Recommended)"*

Untuk membedakan produk dari Vendor C dengan vendor lain, Lead Integrator menambahkan suffix "(Recommended)" pada nama produk. Ini mencerminkan positioning bisnis restoran Vendor C sebagai rekomendasi khusus dalam marketplace. Contohnya, "Nasi Tempong" menjadi "Nasi Tempong (Recommended)".

*Tahap 5: Penyeragaman ID dengan Prefix*

ID dari Vendor C diberikan prefix "A" untuk membedakannya dengan vendor lain. Contohnya, ID 501 menjadi "A501". Penambahan prefix ini memastikan tidak ada collision antara ID dari berbagai vendor dalam dataset terintegrasi.

Berikut adalah snippet kode dari `integratorController.js` yang menunjukkan implementasi normalisasi Vendor C:

```javascript
const normalizedDataC = dataC.map(item => {
    const id = "A" + item.id;

    let productName = item.details.name + " (Recommended)";

    let price = item.pricing.base_price + item.pricing.tax;

    let statusStok = "Tidak Tersedia";
    if(item.stock > 0) {
        statusStok = "Tersedia";
    }
    
    return {
        id: id,
        nama: productName,
        harga_final: price,
        status: statusStok,
        sumber: "Vendor C"
    };
});
```

Proses normalisasi Vendor C menunjukkan kompleksitas yang lebih tinggi dari vendor lain, mencerminkan keragaman data dan logika bisnis yang lebih sophisticated dalam sistem restoran. Lead Integrator harus teliti dalam menangani nested object traversal dan perhitungan harga untuk memastikan integritas data di dashboard terpusat.