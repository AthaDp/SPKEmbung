class Alternatif {
  final String id;
  final String kode;
  final List<String> parameterkriteria;
  final String nama;

  const Alternatif({
    this.id,
    this.kode,
    this.nama,
    this.parameterkriteria
  });

  factory Alternatif.fromMap(Map data) {
    data = data ?? {};
    return Alternatif(
    kode: data["kode_alternatif"] ?? '',
    nama: data["nama_alternatif"] ?? '',
    parameterkriteria: data["kriteria"] ?? '',
    );
  }
}

class Kriteria {
  final String id;
  final String bobot;
  final String nama;
  final String keterangan;
  final String kode;
  final String nilai;

  const Kriteria({
    this.id,
    this.bobot,
    this.nama,
    this.keterangan,
    this.kode,
    this.nilai
  });

  Kriteria.fromMap(Map<String, dynamic> data, String id)
  :this(
    id: id,
    bobot: data["kode_kriteria"],
    nama: data["nama_kriteria"],
    keterangan: data["keterangan"],
    kode: data["kode"],
    nilai:data["nilai_kriteria"]
  );
}