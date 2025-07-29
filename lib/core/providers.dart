import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/repositories/local_repository_impl.dart';
import 'data/repositories/sequence_repository_impl.dart';
import 'domain/repositories/local_repository.dart';
import 'domain/repositories/sequence_repository.dart';

// --- LocalRepositories Providers ---
final localRepositoryProvider = Provider<LocalRepository>((ref) => LocalRepositoryImpl());
final sequenceRepositoryProvider = Provider<SequenceRepository>((ref) => SequenceRepositoryImpl());
