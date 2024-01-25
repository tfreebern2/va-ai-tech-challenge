import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semperMade/upload/cubit/upload_cubit.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> _selectFiles(BuildContext context) async {
    const jpgsTypeGroup = XTypeGroup(
      label: 'JPEGs',
      extensions: <String>['jpg', 'jpeg'],
    );
    const pngTypeGroup = XTypeGroup(
      label: 'PNGs',
      extensions: <String>['png'],
    );
    final files = await openFiles(
      acceptedTypeGroups: <XTypeGroup>[
        jpgsTypeGroup,
        pngTypeGroup,
      ],
    );
    if (context.mounted) {
      await context.read<UploadCubit>().selectFiles(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadCubit, UploadState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UploadLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UploadInitial) {
          return Center(
            child: Column(
              children: [
                const Spacer(),
                const Text('No files selected', style: TextStyle(fontSize: 24)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () => _selectFiles(context),
                    child: const Text('Select File(s)'),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is UploadSelected) {
          return Center(
            child: Column(
              children: [
                if (state.files.isNotEmpty)
                  Text(
                    'Selected ${state.files.length} file(s)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                if (state.files.isEmpty)
                  const Text(
                    'No files selected',
                    style: TextStyle(fontSize: 24),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.files.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(state.files[index].name),
                          subtitle: Text(
                            // ignore: lines_longer_than_80_chars
                            'Last Modified: ${state.fileToLastModified[state.files[index].name]}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context
                                  .read<UploadCubit>()
                                  .removeFile(state.files[index].name);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectFiles(context),
                        child: Text(
                          state.files.isEmpty
                              ? 'Select File(s)'
                              : 'Add File(s)',
                        ),
                      ),
                      if (state.files.isNotEmpty)
                        ElevatedButton(
                          onPressed: () =>
                              context.read<UploadCubit>().upload(state.files),
                          child: const Text('Upload File(s)'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _selectFiles(context),
                  child: const Text('Select File(s)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
