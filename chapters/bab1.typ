= Pendahuluan

== Deskripsi Kasus
"Banyuwangi Marketplace" adalah inisiatif Pemerintah Kabupaten Banyuwangi untuk mengintegrasikan data produk UMKM dari berbagai aplikasi kasir ke dalam satu dashboard terpusat. Tantangan utama adalah perbedaan struktur data (JSON Schema) dari masing-masing vendor aplikasi kasir.

== Tujuan Laporan
Laporan ini bertujuan mendokumentasikan proses integrasi data dari tiga vendor berbeda, normalisasi data, serta penerapan logika bisnis sesuai ketentuan soal.

== Pembagian Peran Anggota

#table(
  columns: (auto, 1fr, auto, 1fr),
  [*No*], [*Nama Mahasiswa*], [*NIM*], [*Peran*],
  [1], [Muhammad Ainul Huda], [362458302075], [Vendor A (WarungLegacy)],
  [2], [Danil Amrulloh], [362458302131], [Vendor B (DistroModern)],
  [3], [M. Hilmi Zamzami], [362458302071], [Vendor C (Resto & Kuliner)],
  [4], [M. Abdul Ghofur], [362458302016], [Lead Integrator],
)

Setiap anggota bertanggung jawab pada simulasi data dan logika sesuai peran vendor masing-masing. Lead Integrator bertugas mengkoordinasikan integrasi data dari ketiga vendor dan memastikan alur kerja berjalan sesuai dengan spesifikasi yang telah ditetapkan.