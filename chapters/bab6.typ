== Rencana Testing

Testing adalah fase kritis dalam pengembangan sistem integrasi untuk memastikan bahwa data dari ketiga vendor berhasil diambil, dinormalisasi, dan diintegrasikan dengan benar sesuai dengan unified schema yang telah ditentukan. Rencana testing untuk proyek Banyuwangi Marketplace meliputi pengujian pada setiap tahap integrasi: testing API individual vendor, testing normalisasi data masing-masing vendor, dan testing hasil akhir integrasi.

Tujuan utama testing adalah memvalidasi bahwa: (1) setiap vendor API merespons dengan data yang sesuai struktur yang diharapkan, (2) proses normalisasi berhasil mengkonversi data ke unified schema tanpa kesalahan, (3) kalkulasi harga (diskon, pajak) dilakukan dengan benar, (4) konversi status ketersediaan produk seragam di semua vendor, dan (5) penggabungan data dari ketiga vendor menghasilkan dataset yang konsisten dan lengkap.

Testing dilakukan menggunakan aplikasi Postman, yang memungkinkan Lead Integrator untuk mengirimkan request HTTP ke setiap endpoint dan menganalisis response yang diterima secara detail. Postman juga mendukung automated testing dengan test scripts dan memvisualisasikan data response dalam berbagai format seperti JSON dan tabel.

== Endpoint Testing

Proyek Banyuwangi Marketplace memiliki beberapa endpoint yang perlu ditest untuk memvalidasi integrasi data:

*1. Endpoint Vendor A*

```
GET http://localhost:3000/api/vendor-a
```

Endpoint ini mengambil data produk dari Vendor A (WarungLegacy) dalam format original vendor. Response berupa array JSON dengan struktur field: `kd_produk`, `nm_brg`, `hrg`, `ket_stok`. Testing endpoint ini memverifikasi bahwa API Vendor A accessible dan merespon dengan data yang sesuai.

*2. Endpoint Vendor B*

```
GET http://localhost:3000/api/vendor-b
```

Endpoint ini mengambil data produk dari Vendor B (DistroModern) dalam format original vendor. Response berupa array JSON dengan struktur field: `sku`, `productName`, `price`, `isAvailable`. Testing endpoint ini memastikan bahwa Vendor B API berfungsi dan data yang diterima memiliki tipe data yang proper (Number, Boolean).

*3. Endpoint Vendor C*

```
GET http://localhost:3000/api/vendor-c
```

Endpoint ini mengambil data produk dari Vendor C (Resto & Kuliner) dalam format original vendor. Response berupa array JSON dengan struktur nested: `id`, `details` (berisi name dan category), `pricing` (berisi base_price dan tax), `stock`. Testing endpoint ini mengverifikasi bahwa proses ekstraksi dari nested objects berjalan dengan sempurna.

*4. Endpoint Integrasi Marketplace*

```
GET http://localhost:3000/
```

Endpoint ini adalah endpoint utama yang mengembalikan hasil integrasi dari ketiga vendor. Lead Integrator telah melakukan normalisasi data sebelum mengembalikan response. Response berupa array JSON dengan struktur unified schema: `id`, `nama`, `harga_final`, `status`, `sumber`. Testing endpoint ini adalah yang paling kritis karena memvalidasi keseluruhan proses integrasi.

== Test Case dan Hasil

Berikut adalah tabel komprehensif yang menunjukkan test case dan hasil testing untuk setiap endpoint:

#table(
  columns: (0.8cm, 2.5cm, 1.8cm, 2.2cm, 2.2cm),
  [*No*], [*Endpoint*], [*Method*], [*Expected Status*], [*Actual Result*],
  [1], [`/api/vendor-a`], [GET], [200 OK], [✓ Pass],
  [2], [`/api/vendor-b`], [GET], [200 OK], [✓ Pass],
  [3], [`/api/vendor-c`], [GET], [200 OK], [✓ Pass],
  [4], [`/`], [GET], [200 OK], [✓ Pass],
  [5], [vendor-a response type], [Validation], [Array of objects], [✓ Pass],
  [6], [vendor-b response type], [Validation], [Array of objects], [✓ Pass],
  [7], [vendor-c response type], [Validation], [Array of objects], [✓ Pass],
  [8], [Integrator response type], [Validation], [Array of objects], [✓ Pass],
  [9], [Vendor A field mapping], [Validation], [id, nama, harga_final, status], [✓ Pass],
  [10], [Vendor B field mapping], [Validation], [id, nama, harga_final, status], [✓ Pass],
  [11], [Vendor C field mapping], [Validation], [id, nama + (Recommended), harga_final], [✓ Pass],
  [12], [Harga Vendor A diskon], [Calculation], [15000 × 0.9 = 13500], [✓ Pass],
  [13], [Harga Vendor C pajak], [Calculation], [20000 + 2000 = 22000], [✓ Pass],
  [14], [Status konversi Vendor A], [Conversion], ["ada" → "Tersedia"], [✓ Pass],
  [15], [Status konversi Vendor C], [Conversion], [stock > 0 → "Tersedia"], [✓ Pass],
  [16], [Data count A], [Count], [4 produk], [✓ Pass],
  [17], [Data count B], [Count], [4 produk], [✓ Pass],
  [18], [Data count C], [Count], [7 produk], [✓ Pass],
  [19], [Total integrated data], [Count], [15 produk (4+4+7)], [✓ Pass],
  [20], [Source tracking], [Validation], [Setiap item memiliki field sumber], [✓ Pass],
)

*Penjelasan Hasil Testing:*

Pengujian menunjukkan bahwa semua endpoint berhasil merespons dengan status 200 OK, mengindikasikan bahwa server dan API routes dikonfigurasi dengan benar. Setiap vendor API mengembalikan data dalam format JSON array yang sesuai dengan struktur yang diharapkan. Response dari endpoint integrasi marketplace (`/`) menunjukkan bahwa data dari ketiga vendor berhasil diambil secara parallel dan diproses melalui normalisasi.

Validasi field mapping menunjukkan bahwa Lead Integrator berhasil melakukan pemetaan field dari setiap vendor ke unified schema. Field `id` dari Vendor A dan C ditambahkan dengan prefix, field `nama` dari semua vendor berhasil dimapping ke field yang sama di unified schema, dan field `sumber` berhasil ditambahkan untuk tracking.

Pengujian kalkulasi harga menunjukkan bahwa formula diskon 10% untuk Vendor A bekerja benar (15000 × 0.9 = 13500) dan formula pajak untuk Vendor C bekerja benar (base_price + tax). Pengujian konversi status menunjukkan bahwa nilai-nilai dari berbagai format vendor berhasil dikonversi ke format string yang seragam.

Pengujian data count menunjukkan bahwa tidak ada data yang hilang atau duplikat dalam proses integrasi. Total 15 produk dari ketiga vendor berhasil terintegrasi, dan setiap item memiliki field `sumber` yang memudahkan tracking asal data.

== Analisis Hasil Testing

Berdasarkan hasil testing yang komprehensif, sistem integrasi Banyuwangi Marketplace telah berhasil diimplementasikan dengan baik. Semua 20 test case berstatus "Pass", menunjukkan bahwa proses integrasi data dari tiga vendor dengan karakteristik unik berjalan sesuai dengan rencana dan menghasilkan output yang sesuai dengan unified schema.

*Keberhasilan Integrasi:*

Integrasi data dari ketiga vendor berhasil dengan tingkat success rate 100%. Data dari Vendor A (dengan naming convention lokal dan tipe data string), Vendor B (dengan naming convention modern dan tipe data proper), dan Vendor C (dengan struktur nested dan sistem pajak) berhasil dinormalisasi ke dalam unified schema tanpa error atau data loss. Hal ini membuktikan bahwa desain unified schema dan algoritma normalisasi yang dikembangkan Lead Integrator adalah robust dan capable menangani keragaman format data vendor.

*Konsistensi Data:*

Hasil testing menunjukkan bahwa proses normalisasi berhasil memastikan konsistensi data di seluruh marketplace. Field-field dari berbagai vendor berhasil dimapping dengan benar, kalkulasi harga berhasil dilakukan sesuai logika bisnis masing-masing vendor, dan konversi status ketersediaan berhasil menghasilkan format yang seragam. Lead Integrator dapat melanjutkan ke tahap pengembangan berikutnya dengan confidence bahwa data yang disimpan di marketplace memiliki kualitas tinggi dan format yang konsisten.

*Tidak Ada Anomali Kritis:*

Testing tidak menemukan anomali kritis yang dapat mengganggu operasi marketplace. Data yang diterima dari ketiga vendor tidak ada yang kosong (null), tidak ada duplikasi ID yang menimbulkan collision, dan tidak ada kalkulasi harga yang menghasilkan nilai negatif atau tidak valid. Semua status ketersediaan berhasil dikonversi dengan benar dan tidak ada mismatch antara struktur data yang diterima dan unified schema yang diharapkan.

*Rekomendasi Lanjutan:*

Untuk meningkatkan robustness sistem lebih lanjut, Lead Integrator dapat mempertimbangkan: (1) menambahkan pagination untuk menangani dataset yang lebih besar, (2) mengimplementasikan caching untuk meningkatkan performance ketika ada banyak request concurrent, (3) menambahkan endpoint untuk filtering dan sorting data terintegrasi sesuai kebutuhan user, dan (4) mengimplementasikan logging yang lebih detail untuk debugging dan monitoring purposes.

== Dokumentasi Testing dengan Postman

Testing dilakukan menggunakan aplikasi Postman untuk memastikan setiap endpoint dapat diakses dan merespons dengan data yang valid. Berikut adalah dokumentasi testing:

*Request Testing Endpoint Vendor A:*

- *URL*: `http://localhost:3000/api/vendor-a`
- *Method*: GET
- *Headers*: Content-Type: application/json
- *Response Status*: 200 OK
- *Response Body*: Array of 4 products dengan field kd_produk, nm_brg, hrg, ket_stok

*Request Testing Endpoint Vendor B:*

- *URL*: `http://localhost:3000/api/vendor-b`
- *Method*: GET
- *Headers*: Content-Type: application/json
- *Response Status*: 200 OK
- *Response Body*: Array of 4 products dengan field sku, productName, price, isAvailable

*Request Testing Endpoint Vendor C:*

- *URL*: `http://localhost:3000/api/vendor-c`
- *Method*: GET
- *Headers*: Content-Type: application/json
- *Response Status*: 200 OK
- *Response Body*: Array of 7 products dengan nested structure (id, details, pricing, stock)

*Request Testing Endpoint Integrasi Marketplace:*

- *URL*: `http://localhost:3000/`
- *Method*: GET
- *Headers*: Content-Type: application/json
- *Response Status*: 200 OK
- *Response Body*: Array of 15 integrated products dengan unified schema (id, nama, harga_final, status, sumber)

*Fitur Postman yang Digunakan:*

Lead Integrator menggunakan beberapa fitur Postman untuk memaksimalkan proses testing:

1. *Collections*: Membuat collection bernama "Banyuwangi Marketplace Testing" yang berisi semua endpoint requests untuk organisasi yang lebih baik.

2. *Environment Variables*: Menggunakan environment variable `{{base_url}}` dengan nilai `http://localhost:3000` untuk memudahkan perubahan URL ketika deploy ke environment berbeda.

3. *Pre-request Scripts*: Menambahkan script untuk melakukan setup sebelum request (misalnya logging timestamp request).

4. *Tests*: Menambahkan test scripts di tab "Tests" untuk melakukan validasi response secara otomatis, seperti checking status code, tipe data response, dan nilai-nilai tertentu.

5. *Response Visualization*: Menggunakan fitur pretty-print untuk memvisualisasikan JSON response agar lebih mudah dibaca dan dianalisis.

Testing dengan Postman membuktikan bahwa sistem integrasi Banyuwangi Marketplace telah siap untuk digunakan dan dapat diandalkan dalam mengintegrasikan data dari tiga vendor yang berbeda.