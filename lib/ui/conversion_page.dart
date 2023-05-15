import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  static const routeName = '/conversion_page';

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

enum ConversionType { currency, timezone }

class _ConversionPageState extends State<ConversionPage> {
  ConversionType _conversionType = ConversionType.currency;
  double _amount = 0.0;
  double _result = 0.0;
  String _sourceCurrency = 'IDR';
  String _targetCurrency = 'USD';
  final _textEditingController = TextEditingController();

  String _targetTimezone = 'WIT';
  DateTime _sourceDateTime = DateTime.now();
  DateTime _targetDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _amount = double.tryParse(_textEditingController.text) ?? 0.0;
      });
    });
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _sourceDateTime = DateTime.now();
        convertTimezone(_sourceDateTime, _targetTimezone);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton(
                value: _conversionType,
                items: const [
                  DropdownMenuItem(
                    value: ConversionType.currency,
                    child: Text('Mata Uang'),
                  ),
                  DropdownMenuItem(
                    value: ConversionType.timezone,
                    child: Text('Zona Waktu'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _conversionType = value as ConversionType;
                  });
                }),
            const SizedBox(height: 16),
            Expanded(
              child: _conversionType == ConversionType.currency
                  ? _buildCurrency()
                  : _buildTimezone(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrency() {
    final currencies = ['IDR', 'USD', 'EUR', 'GBP', 'CAD', 'BTC'];

    double convertCurrency(
        double amount, String fromCurrency, String toCurrency) {
      final rates = {
        'USD': 1,
        'IDR': 14823,
        'EUR': 0.92,
        'GBP': 0.80,
        'CAD': 1.21,
        'BTC': 0.000037,
      };
      final sourceRate = rates[fromCurrency] ?? 1.0;
      final targetRate = rates[toCurrency] ?? 1.0;
      final exchangeRate = targetRate / sourceRate;
      return amount * exchangeRate;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            controller: _textEditingController,
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value) ?? 0.0;
                _result =
                    convertCurrency(_amount, _sourceCurrency, _targetCurrency);
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _sourceCurrency,
                items: currencies
                    .map((currency) => DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _sourceCurrency = value ?? 'USD';
                    _result = convertCurrency(
                        _amount, _sourceCurrency, _targetCurrency);
                  });
                },
              ),
              const Text('to'),
              DropdownButton<String>(
                value: _targetCurrency,
                items: currencies
                    .map((currency) => DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _targetCurrency = value ?? 'EUR';
                    _result = convertCurrency(
                        _amount, _sourceCurrency, _targetCurrency);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$_amount $_sourceCurrency = $_result $_targetCurrency',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  void convertTimezone(DateTime dateTime, String targetTimezone) {
    final targetTime = getTimezoneOffset(targetTimezone);
    _targetDateTime =
        dateTime.add(targetTime).subtract(DateTime.now().timeZoneOffset);
  }

  Duration getTimezoneOffset(String timezone) {
    switch (timezone) {
      case 'WIB':
        return const Duration(hours: 7);
      case 'WIT':
        return const Duration(hours: 9);
      case 'WITA':
        return const Duration(hours: 8);
      case 'London':
        return Duration.zero;
      case 'New York':
        return const Duration(hours: -4);
      case 'Tokyo':
        return const Duration(hours: 9);
      default:
        return Duration.zero;
    }
  }

  Widget _buildTimezone() {
    final timezones = ['WIB', 'WITA', 'WIT', 'London', 'New York', 'Tokyo'];

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    return Container(
        padding: const EdgeInsets.all(16),
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Waktu Lokal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dateFormat.format(_sourceDateTime),
                          style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Target Timezone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: _targetTimezone,
                        items: timezones
                            .map((timezone) => DropdownMenuItem<String>(
                                  value: timezone,
                                  child: Text(timezone),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _targetTimezone = value ?? 'WIT';
                            convertTimezone(_sourceDateTime, _targetTimezone);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Waktu Target',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dateFormat.format(_targetDateTime),
                          style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                ])));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
    });
    super.dispose();
  }
}
