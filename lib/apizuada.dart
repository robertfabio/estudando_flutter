import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. CLASSE MODELO PARA OS DETALHES DO VEÍCULO
class VehicleDetails {
  final String price;
  final String brand;
  final String model;
  final int modelYear;
  final String fuel;
  final String fipeCode;
  final String referenceMonth;
  final int vehicleType;
  final String fuelAcronym;

  VehicleDetails({
    required this.price,
    required this.brand,
    required this.model,
    required this.modelYear,
    required this.fuel,
    required this.fipeCode,
    required this.referenceMonth,
    required this.vehicleType,
    required this.fuelAcronym,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      price: json['price'] as String? ?? 'N/A',
      brand: json['brand'] as String? ?? 'N/A',
      model: json['model'] as String? ?? 'N/A',
      modelYear: json['modelYear'] as int? ?? 0,
      fuel: json['fuel'] as String? ?? 'N/A',
      fipeCode: json['codeFipe'] as String? ?? 'N/A', // Chave na API é 'codeFipe'
      referenceMonth: json['referenceMonth'] as String? ?? 'N/A',
      vehicleType: json['vehicleType'] as int? ?? 0,
      fuelAcronym: json['fuelAcronym'] as String? ?? 'N/A',
    );
  }
}

// 2. FUNÇÃO PARA CHAMAR A API DE DETALHES
Future<VehicleDetails> getVehicleDetails({
  required String vehicleType,
  required String brandCode,
  required String modelCode,
  required String yearId,
}) async {
  final String apiUrl = "https://fipe.parallelum.com.br/api/v2/$vehicleType/brands/$brandCode/models/$modelCode/years/$yearId";
  print("Chamando API de Detalhes: $apiUrl");

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return VehicleDetails.fromJson(jsonData);
    } else {
      print("Erro na API de Detalhes: ${response.statusCode}");
      print("Corpo da resposta de Detalhes: ${response.body}");
      throw Exception('Falha ao carregar detalhes do veículo. Código: ${response.statusCode}');
    }
  } catch (e) {
    print("Exceção ao chamar API de Detalhes: $e");
    throw Exception('Erro ao buscar detalhes do veículo: $e');
  }
}

// Classe Modelo para Marcas
class Brand {
  final String name;
  final String code;

  Brand({required this.name, required this.code});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'] as String? ?? 'N/A',
      code: json['code'] as String? ?? 'N/A',
    );
  }
}

// Função para buscar Marcas
Future<List<Brand>> getBrands(String vehicleType) async {
  final String apiUrl = "https://fipe.parallelum.com.br/api/v2/$vehicleType/brands";
  print("Chamando API de Marcas: $apiUrl");

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((jsonItem) => Brand.fromJson(jsonItem)).toList();
    } else {
      print("Erro na API de Marcas: ${response.statusCode}");
      print("Corpo da resposta de Marcas: ${response.body}");
      throw Exception('Falha ao carregar marcas. Código: ${response.statusCode}');
    }
  } catch (e) {
    print("Exceção ao chamar API de Marcas: $e");
    throw Exception('Erro ao buscar marcas: $e');
  }
}

// Classe Modelo para Modelos de Veículos
class Model {
  final String name;
  final String code; // Este será o modelCode para a API

  Model({required this.name, required this.code});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      name: json['name'] as String? ?? 'N/A',
      code: json['code'] as String? ?? 'N/A', // A API de modelos retorna 'code'
    );
  }
}

// Função para buscar Modelos de uma Marca específica
Future<List<Model>> getModels(String vehicleType, String brandCode) async {
  final String apiUrl = "https://fipe.parallelum.com.br/api/v2/$vehicleType/brands/$brandCode/models";
  print("Chamando API de Modelos: $apiUrl");

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((jsonItem) => Model.fromJson(jsonItem)).toList();
    } else {
      print("Erro na API de Modelos: ${response.statusCode}");
      print("Corpo da resposta de Modelos: ${response.body}");
      throw Exception('Falha ao carregar modelos. Código: ${response.statusCode}');
    }
  } catch (e) {
    print("Exceção ao chamar API de Modelos: $e");
    throw Exception('Erro ao buscar modelos: $e');
  }
}

// Classe Modelo para Anos/Versões de um Modelo de Veículo
class VehicleYear {
  final String name; // Ex: "2023 Gasolina", "Zero KM Gasolina"
  final String code; // Este será o yearId para a API de detalhes

  VehicleYear({required this.name, required this.code});

  factory VehicleYear.fromJson(Map<String, dynamic> json) {
    return VehicleYear(
      name: json['name'] as String? ?? 'N/A',
      code: json['code'] as String? ?? 'N/A',
    );
  }
}

// Função para buscar Anos/Versões de um Modelo específico
Future<List<VehicleYear>> getYears(String vehicleType, String brandCode, String modelCode) async {
  final String apiUrl = "https://fipe.parallelum.com.br/api/v2/$vehicleType/brands/$brandCode/models/$modelCode/years";
  print("Chamando API de Anos/Versões: $apiUrl");

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((jsonItem) => VehicleYear.fromJson(jsonItem)).toList();
    } else {
      print("Erro na API de Anos/Versões: ${response.statusCode}");
      print("Corpo da resposta de Anos/Versões: ${response.body}");
      throw Exception('Falha ao carregar anos/versões. Código: ${response.statusCode}');
    }
  } catch (e) {
    print("Exceção ao chamar API de Anos/Versões: $e");
    throw Exception('Erro ao buscar anos/versões: $e');
  }
}


// 3. WIDGET DA TELA PARA EXIBIR OS DETALHES
class VehicleDetailsPage extends StatefulWidget {
  final String vehicleType;
  final String brandCode;
  final String modelCode;
  final String yearId;


  const VehicleDetailsPage({
    super.key,
    required this.vehicleType,
    required this.brandCode,
    required this.modelCode,
    required this.yearId,
  });

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  late Future<VehicleDetails> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = getVehicleDetails(
      vehicleType: widget.vehicleType,
      brandCode: widget.brandCode,
      modelCode: widget.modelCode,
      yearId: widget.yearId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Veículo"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<VehicleDetails>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Erro ao carregar: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final details = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      _buildDetailRow("Preço:", details.price),
                      _buildDetailRow("Marca:", details.brand),
                      _buildDetailRow("Modelo:", details.model),
                      _buildDetailRow("Ano Modelo:", details.modelYear.toString()),
                      _buildDetailRow("Combustível:", "${details.fuel} (${details.fuelAcronym})"),
                      _buildDetailRow("Código FIPE:", details.fipeCode),
                      _buildDetailRow("Mês de Referência:", details.referenceMonth),
                      const SizedBox(height: 20),
                      Text(
                        "Tipo de Veículo (código API): ${details.vehicleType}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child: Text("Nenhum detalhe encontrado.", style: TextStyle(fontSize: 16)));
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. TELA DE ENTRADA E SELEÇÃO DE MARCA
class VehicleInputPage extends StatefulWidget {
  const VehicleInputPage({super.key});

  @override
  State<VehicleInputPage> createState() => _VehicleInputPageState();
}

class _VehicleInputPageState extends State<VehicleInputPage> {
  final _formKey = GlobalKey<FormState>();

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  bool _isLoadingBrands = false;
  String? _selectedVehicleTypeApiValue;

  final _brandFilterController = TextEditingController();

  final Map<String, String> _vehicleTypes = {
    'Carros': 'cars',
    'Motos': 'motorcycles',
    'Caminhões': 'trucks',
  };

  @override
  void initState() {
    super.initState();
    _brandFilterController.addListener(_filterBrands);
  }

  @override
  void dispose() {
    _brandFilterController.removeListener(_filterBrands);
    _brandFilterController.dispose();
    super.dispose();
  }

  void _fetchBrands() async {
    if (_selectedVehicleTypeApiValue == null || _selectedVehicleTypeApiValue!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecione um tipo de veículo.")),
      );
      return;
    }

    setState(() {
      _isLoadingBrands = true;
      _allBrands = [];
      _filteredBrands = [];
      _brandFilterController.clear();
    });

    try {
      final brands = await getBrands(_selectedVehicleTypeApiValue!);
      setState(() {
        _allBrands = brands;
        _filteredBrands = brands;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao buscar marcas: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBrands = false;
        });
      }
    }
  }

  void _filterBrands() {
    final filterText = _brandFilterController.text.toLowerCase();
    setState(() {
      _filteredBrands = _allBrands.where((brand) {
        return brand.name.toLowerCase().contains(filterText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecionar Tipo e Marca"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Veículo',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedVehicleTypeApiValue,
                    hint: const Text("Selecione o tipo"),
                    items: _vehicleTypes.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleTypeApiValue = value;
                        _fetchBrands();
                      });
                    },
                    validator: (value) => value == null ? 'Selecione um tipo' : null,
                  ),
                  const SizedBox(height: 16),
                  if (_allBrands.isNotEmpty || _isLoadingBrands)
                    TextFormField(
                      controller: _brandFilterController,
                      decoration: const InputDecoration(
                        labelText: 'Filtrar marca por nome...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoadingBrands)
              const Center(child: CircularProgressIndicator()),
            if (!_isLoadingBrands && _filteredBrands.isEmpty && _selectedVehicleTypeApiValue != null)
              Expanded(
                child: Center(
                  child: Text(
                    _allBrands.isEmpty && _brandFilterController.text.isEmpty
                        ? "Nenhuma marca encontrada para o tipo selecionado."
                        : "Nenhuma marca corresponde ao filtro.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredBrands.length,
                itemBuilder: (context, index) {
                  final brand = _filteredBrands[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(brand.name),
                      subtitle: Text("Código: ${brand.code}"),
                      onTap: () {
                        if (_selectedVehicleTypeApiValue != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModelSelectionPage(
                                vehicleType: _selectedVehicleTypeApiValue!,
                                brandCode: brand.code,
                                brandName: brand.name,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TELA DE SELEÇÃO DE MODELO
class ModelSelectionPage extends StatefulWidget {
  final String vehicleType;
  final String brandCode;
  final String brandName;

  const ModelSelectionPage({
    super.key,
    required this.vehicleType,
    required this.brandCode,
    required this.brandName,
  });

  @override
  State<ModelSelectionPage> createState() => _ModelSelectionPageState();
}

class _ModelSelectionPageState extends State<ModelSelectionPage> {
  List<Model> _allModels = [];
  List<Model> _filteredModels = [];
  bool _isLoadingModels = true;
  final _modelFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchModels();
    _modelFilterController.addListener(_filterModels);
  }

  @override
  void dispose() {
    _modelFilterController.removeListener(_filterModels);
    _modelFilterController.dispose();
    super.dispose();
  }

  void _fetchModels() async {
    setState(() {
      _isLoadingModels = true;
      _allModels = [];
      _filteredModels = [];
    });
    try {
      final models = await getModels(widget.vehicleType, widget.brandCode);
      setState(() {
        _allModels = models;
        _filteredModels = models;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao buscar modelos: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingModels = false;
        });
      }
    }
  }

  void _filterModels() {
    final filterText = _modelFilterController.text.toLowerCase();
    setState(() {
      _filteredModels = _allModels.where((model) {
        return model.name.toLowerCase().contains(filterText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modelos ${widget.brandName}"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _modelFilterController,
              decoration: const InputDecoration(
                labelText: 'Filtrar modelo por nome...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoadingModels)
              const Center(child: CircularProgressIndicator()),
            if (!_isLoadingModels && _filteredModels.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    _allModels.isEmpty && _modelFilterController.text.isEmpty
                        ? "Nenhum modelo encontrado para esta marca."
                        : "Nenhum modelo corresponde ao filtro.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredModels.length,
                itemBuilder: (context, index) {
                  final model = _filteredModels[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(model.name),
                      subtitle: Text("Código: ${model.code}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YearSelectionPage(
                              vehicleType: widget.vehicleType,
                              brandCode: widget.brandCode,
                              modelCode: model.code,
                              modelName: model.name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TELA DE SELEÇÃO DE ANO/VERSÃO
class YearSelectionPage extends StatefulWidget {
  final String vehicleType;
  final String brandCode;
  final String modelCode;
  final String modelName;

  const YearSelectionPage({
    super.key,
    required this.vehicleType,
    required this.brandCode,
    required this.modelCode,
    required this.modelName,
  });

  @override
  State<YearSelectionPage> createState() => _YearSelectionPageState();
}

class _YearSelectionPageState extends State<YearSelectionPage> {
  List<VehicleYear> _vehicleYears = [];
  bool _isLoadingYears = true;

  @override
  void initState() {
    super.initState();
    _fetchYears();
  }

  void _fetchYears() async {
    setState(() {
      _isLoadingYears = true;
      _vehicleYears = [];
    });
    try {
      final years = await getYears(widget.vehicleType, widget.brandCode, widget.modelCode);
      setState(() {
        _vehicleYears = years;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao buscar anos/versões: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingYears = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ano/Versão - ${widget.modelName}"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (_isLoadingYears)
              const Center(child: CircularProgressIndicator()),
            if (!_isLoadingYears && _vehicleYears.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "Nenhum ano/versão encontrado para este modelo.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _vehicleYears.length,
                itemBuilder: (context, index) {
                  final year = _vehicleYears[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(year.name),
                      subtitle: Text("Código: ${year.code}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailsPage(
                              vehicleType: widget.vehicleType,
                              brandCode: widget.brandCode,
                              modelCode: widget.modelCode,
                              yearId: year.code,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 5. FUNÇÃO MAIN E APP WIDGET
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta FIPE',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.amber),
      ),
      debugShowCheckedModeBanner: false,
      home: const VehicleInputPage(),
    );
  }
}
