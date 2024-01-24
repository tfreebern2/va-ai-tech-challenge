import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit({
    List<XFile>? initialFiles,
    Map<String, String>? fileToLastModified,
  })  : _files = initialFiles ?? [],
        _fileToLastModified = fileToLastModified ?? {},
        super(UploadInitial());

  final List<XFile> _files;
  final Map<String, String> _fileToLastModified;

  Future<void> selectFiles(List<XFile> files) async {
    emit(UploadLoading());
    _files.addAll(files);
    await Future.wait<void>(
      _files.map(
        (file) async {
          final lastModified = await file.lastModified();
          final formattedDate =
              DateFormat.yMMMMd().add_jm().format(lastModified);
          _fileToLastModified.containsKey(file.name)
              ? _fileToLastModified.update(
                  file.name,
                  (value) => formattedDate,
                )
              : _fileToLastModified.putIfAbsent(
                  file.name,
                  () => formattedDate,
                );
        },
      ),
    );
    emit(UploadSelected(List.from(_files), _fileToLastModified));
  }

  void removeFile(String fileName) {
    emit(UploadLoading());
    _files.removeWhere((file) => file.name == fileName);
    _fileToLastModified.remove(fileName);
    emit(UploadSelected(List.from(_files), _fileToLastModified));
  }

  Future<void> upload(List<XFile> files) async {
    emit(UploadLoading());
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(UploadSuccess());
  }
}
