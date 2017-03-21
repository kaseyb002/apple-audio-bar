import AVFoundation

public struct AudioTags {

    var title: String?
    var artistName: String?
    var albumName: String?
    var artworkData: Data?

    init(commonMetadata: [AVMetadataItem]) {
        for item in commonMetadata {
            guard let key = item.commonKey else { continue }
            switch key {
            case AVMetadataCommonKeyTitle:
                title = item.stringValue
            case AVMetadataCommonKeyArtist:
                artistName = item.stringValue
            case AVMetadataCommonKeyAlbumName:
                albumName = item.stringValue
            case AVMetadataCommonKeyArtwork:
                artworkData = item.dataValue
            default:
                break
            }
        }
    }

}
