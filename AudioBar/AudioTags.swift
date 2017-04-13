import AVFoundation

public struct AudioTags {

    let title: String?
    let artistName: String?
    let albumName: String?
    let artworkData: Data?

    init(commonMetadata: [AVMetadataItem]) {

        func metadataItem(forKey key: String) -> AVMetadataItem? {
            for item in commonMetadata where item.commonKey == key {
                return item
            }
            return nil
        }

        title = metadataItem(forKey: AVMetadataCommonKeyTitle)?.stringValue
        artistName = metadataItem(forKey: AVMetadataCommonKeyArtist)?.stringValue
        albumName = metadataItem(forKey: AVMetadataCommonKeyAlbumName)?.stringValue
        artworkData = metadataItem(forKey: AVMetadataCommonKeyArtwork)?.dataValue

    }

}
