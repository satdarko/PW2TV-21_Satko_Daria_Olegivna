import 'package:flutter/material.dart';

void main() {
  runApp(const EmissionsApp());
}

class EmissionsApp extends StatelessWidget {
  const EmissionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emission Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final coalQ = TextEditingController(text: '20.47');
  final coalA = TextEditingController(text: '25.20');
  final coalAvin = TextEditingController(text: '0.8');
  final coalGvin = TextEditingController(text: '1.5');
  final coalNzu = TextEditingController(text: '0.985');
  final coalB = TextEditingController(text: '1096363');

  final mazutQ = TextEditingController(text: '39.48');
  final mazutA = TextEditingController(text: '0.15');
  final mazutAvin = TextEditingController(text: '1.0');
  final mazutGvin = TextEditingController(text: '0.0');
  final mazutNzu = TextEditingController(text: '0.985');
  final mazutB = TextEditingController(text: '70945');

  String resultText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void calculateCoal() {
    double qRi = double.tryParse(coalQ.text) ?? 0.0;
    double aR = double.tryParse(coalA.text) ?? 0.0;
    double aVin = double.tryParse(coalAvin.text) ?? 0.0;
    double gVin = double.tryParse(coalGvin.text) ?? 0.0;
    double nZu = double.tryParse(coalNzu.text) ?? 0.0;
    double b = double.tryParse(coalB.text) ?? 0.0;

    double kTv = (1000000 / qRi) * aVin * (aR / (100 - gVin)) * (1 - nZu);
    double eJ = 0.000001 * kTv * qRi * b;

    setState(() {
      resultText = 'Показник емісії твердих частинок (k): ${kTv.toStringAsFixed(2)} г/ГДж\n'
          'Валовий викид (E): ${eJ.toStringAsFixed(2)} т';
    });
  }

  void calculateMazut() {
    double qRi = double.tryParse(mazutQ.text) ?? 0.0;
    double aR = double.tryParse(mazutA.text) ?? 0.0;
    double aVin = double.tryParse(mazutAvin.text) ?? 0.0;
    double gVin = double.tryParse(mazutGvin.text) ?? 0.0;
    double nZu = double.tryParse(mazutNzu.text) ?? 0.0;
    double b = double.tryParse(mazutB.text) ?? 0.0;

    double kTv = (1000000 / qRi) * aVin * (aR / (100 - gVin)) * (1 - nZu);
    double eJ = 0.000001 * kTv * qRi * b;

    setState(() {
      resultText = 'Показник емісії твердих частинок (k): ${kTv.toStringAsFixed(2)} г/ГДж\n'
          'Валовий викид (E): ${eJ.toStringAsFixed(2)} т';
    });
  }

  void calculateGas() {
    setState(() {
      resultText = 'При спалюванні природного газу тверді частинки відсутні.\n'
          'Валовий викид (E): 0.00 т';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор викидів (ПР2)'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Вугілля'),
            Tab(text: 'Мазут'),
            Tab(text: 'Газ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildForm(
            inputs: [
              buildInput('Qri (МДж/кг)', coalQ),
              buildInput('A (Вміст золи %)', coalA),
              buildInput('a (Частка леткої золи)', coalAvin),
              buildInput('G (Горючі в золі %)', coalGvin),
              buildInput('n (Ефективність очистки)', coalNzu),
              buildInput('B (Витрата палива, т)', coalB),
            ],
            onCalc: calculateCoal,
          ),
          buildForm(
            inputs: [
              buildInput('Qri (МДж/кг)', mazutQ),
              buildInput('A (Вміст золи %)', mazutA),
              buildInput('a (Частка леткої золи)', mazutAvin),
              buildInput('G (Горючі в золі %)', mazutGvin),
              buildInput('n (Ефективність очистки)', mazutNzu),
              buildInput('B (Витрата палива, т)', mazutB),
            ],
            onCalc: calculateMazut,
          ),
          buildForm(
            inputs: [
               const Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text('Для природного газу розрахунок спрощений.'),
               ),
            ],
            onCalc: calculateGas,
          ),
        ],
      ),
    );
  }

  Widget buildForm({required List<Widget> inputs, required VoidCallback onCalc}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...inputs,
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onCalc,
            child: const Text('Розрахувати'),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(
              resultText.isEmpty ? 'Результат буде тут' : resultText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}