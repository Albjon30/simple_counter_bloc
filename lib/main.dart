import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/events/counter_event.dart';
import 'bloc/state/counter_state.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),

    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Testing Bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          builder: (BuildContext context, state) {
            final invalidValue =
            (state is CounterStateInvalidNumber) ? state.invalidValue : ' ';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text('Current Value => ${state.value}'),
                    Visibility(
                      child: Text('Invalid Input: $invalidValue'),
                      visible: state is CounterStateInvalidNumber,
                    ),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Number',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<CounterBloc>().add(
                              DecrementEvent(_controller.text),
                            );
                          },
                          child: const Text('-'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CounterBloc>().add(
                              IncrementEvent(_controller.text),
                            );
                          },
                          child: const Text('+'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {
            _controller.clear();
          },
        ),
      ),
    );
  }
}


