import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:netflix/domain/downloads/i_downloads_repo.dart';
import 'package:netflix/domain/downloads/models/downloads.dart';

part 'fast_laugh_event.dart';
part 'fast_laugh_state.dart';
part 'fast_laugh_bloc.freezed.dart';

final dummyVideoUrls = [
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
];

// final dummyVideoUrls = [
//   "https://pagalstatus.com/wp-content/uploads/2021/10/Game-Of-Thrones-Dragon-Scene-Status-Video.mp4",
//   "https://statuspaji.com/wp-content/uploads/2021/09/Iron-Man-Full-Screen-Status-Video.mp4",
//   "https://statusguide.com/anykreeg/2021/04/Naruto-vs-pain-amv-whatsapp-status.mp4",
//   "https://gostatusguru.com/siteuploads/files/sfd25/12133/Stranger%20Things%20Whatsapp%20Status(GoStatusGuru.Com).mp4",
//   "https://statusour.com/wp-content/uploads/2021/09/Money-Heist-Whatsapp-Status-Video-Download-Full-Screen-4k-Status-9.mp4",
// ];

ValueNotifier<Set<int>> likedVideoIdsNotifier = ValueNotifier({});

@injectable
class FastLaughBloc extends Bloc<FastLaughEvent, FastLaughState> {
  FastLaughBloc(
    IDownloadsRepo _downloadService,
  ) : super(FastLaughState.initial()) {
    on<Initialize>((event, emit) async {
      // TODO: implement event handler
      emit(
        const FastLaughState(
          videoList: [],
          isLoading: true,
          isError: false,
        ),
      );
      final _result = await _downloadService.getDownloadsImage();
      final _state = _result.fold(
        (l) {
          return const FastLaughState(
            videoList: [],
            isLoading: false,
            isError: true,
          );
        },
        (resp) => FastLaughState(
          videoList: resp,
          isLoading: false,
          isError: false,
        ),
      );
      emit(_state);
    });

    on<LikeVideo>((event, emit) async {
      likedVideoIdsNotifier.value.add(event.id);
      likedVideoIdsNotifier.notifyListeners();
    });

    on<UnlikeVideo>((event, emit) async {
      likedVideoIdsNotifier.value.remove(event.id);
      likedVideoIdsNotifier.notifyListeners();
    });
  }
}
