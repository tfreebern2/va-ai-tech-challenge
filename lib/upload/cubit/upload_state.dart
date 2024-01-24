part of 'upload_cubit.dart';

abstract class UploadState extends Equatable {}

class UploadInitial extends UploadState {
  @override
  List<Object> get props => [];
}

class UploadSelected extends UploadState {
  UploadSelected(this.files, this.fileToLastModified);

  final List<XFile> files;
  final Map<String, String> fileToLastModified;

  @override
  List<Object> get props => [files, fileToLastModified];
}

class UploadLoading extends UploadState {
  UploadLoading();

  @override
  List<Object> get props => [];
}

class UploadSuccess extends UploadState {
  @override
  List<Object> get props => [];
}

class UploadError extends UploadState {
  UploadError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
