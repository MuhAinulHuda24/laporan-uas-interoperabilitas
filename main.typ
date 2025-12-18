// main.typ
#import "conf.typ": project
#import "cover.typ": cover_page

// Data Kelompok (Sesuaikan dengan peran di soal)

#let members_data = (
  (name: "Mahasiswa 1", nim: "NIM001", role: "Vendor A (WarungLegacy)"),
  (name: "Mahasiswa 2", nim: "NIM002", role: "Vendor B (DistroModern)"),
  (name: "Mahasiswa 3", nim: "NIM003", role: "Vendor C (Resto & Kuliner)"),
  (name: "Mahasiswa 4", nim: "NIM004", role: "Lead Integrator"),
)


#show: doc => project(
  title: "Laporan Integrasi Data Banyuwangi Marketplace",
  semester: "Ganjil 2025/2026",
  team_number: "01",
  members: members_data,
  doc
)

// Generate Cover

#cover_page(
  title: "Laporan Integrasi Data Banyuwangi Marketplace",
  semester: "Ganjil 2025/2026",
  team_number: "01",
  members: members_data
)

// Include Bab-bab

#include "chapters/bab1.typ"
#include "chapters/bab2.typ"
#include "chapters/bab3.typ"
#include "chapters/bab4.typ"
#include "chapters/bab5.typ"
#include "chapters/bab6.typ"
#include "chapters/bab7.typ"