import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vwede/core/viewModel/signInVm.dart';

final registerProviders = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => SignInVm()),
];