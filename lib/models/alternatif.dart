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
  /*
  Alternatif.fromMap(Map<String, dynamic> data, String id)
  :this(
    id: id,
    kode: data["kode_alternatif"],
    nama: data["nama_alternatif"],
    parameterkriteria: data["kriteria"]
  );*/
}