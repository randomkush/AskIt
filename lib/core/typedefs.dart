// ignore_for_file: file_names
import 'package:fpdart/fpdart.dart';
import 'package:ask_it/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;