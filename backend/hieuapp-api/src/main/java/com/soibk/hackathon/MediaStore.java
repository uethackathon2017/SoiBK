package com.soibk.hackathon;


import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by hieuapp on 11/03/2017.
 */
public class MediaStore {

    public static final String[]  sadMusic = new String[]{
            "http://s1mp3.hot1.cache31.vcdn.vn/d7a2cde66aa283fcdab3/2810680745683881125?key=_cOBYyATLYIFzcxlPUjLAA&expires=1489304177",
            "http://s1mp3.hot1.cache31.vcdn.vn/fdd83c979bd3728d2bc2/5761878433292613079?key=9Q_sRGz8fj9ZlG7m9R1hWg&expires=1489304689"
    };

    public static final String[] relaxMusic = new String[]{
        "http://320.s1.mp3.zdn.vn/65f714fdfbb912e74ba8/3957087340509527650?key=qCzD2liBoUMPMHJvU0Wv-A&expires=1489303215",
        "http://s1mp3.r8s115.vcdn.vn/f78a1c0d1949f017a958/8745458058923444400?key=wYaRr_KafwKUVUChHMhpGA&expires=1489303818",
        "http://s1mp3.hot1.cache31.vcdn.vn/d7a2cde66aa283fcdab3/2810680745683881125?key=_cOBYyATLYIFzcxlPUjLAA&expires=1489304177"
    };

    public static final String[] sadWall = new String[]{
        "http://androidwalls.net/wp-content/uploads/2015/05/Colorful Painted Wood Planks Background Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/03/Scratched Gray Metal Surface Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2014/12/Green Gray Clover Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/04/Dark Metal Steel Clean Android Wallpaper.png",
        "http://androidwalls.net/wp-content/uploads/2015/04/Dark%20Afternoon%20Drops%20Of%20Water%20Android%20Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2015/04/Dark Cosmos Stars Clouds Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2015/03/Dark Nature Meteorites Space Purple Clouds Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2015/03/Black And White Macro Rose Flower Grey Dark Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2014/10/Horror Misty Dark Forest Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2014/07/Macro Water Drops Dark Blue Grass Android Wallpaper.jpg"
    };

    public static final String[] happyWall = new String[]{
        "http://androidwalls.net/wp-content/uploads/2016/08/Pikachu Pokemon Go Character Minimal Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/08/Pidgey Pokemon Go Character Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/08/Funny Banana Lets Get Naked Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/08/Pastel Clouds Sunrise Android Wallpaper.jpeg",
        "http://androidwalls.net/wp-content/uploads/2016/03/Orange Pink Minimal Gradient Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/03/Green Blue Gradient Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/03/Purple Pink Gradient Simple Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/03/Ocean Beach Blur HTC Android Wallpaper.jpg",
        "http://androidwalls.net/wp-content/uploads/2016/03/Green Turquoise Gradient Android Wallpaper.jpg"
    };

    public static final Map<String, String> mediaType;
    static {
        Map<String, String> mapMedia = new HashMap<>();
        mapMedia.put("thất_tình", "sad");
        mapMedia.put("bị_đá", "sad");
        mapMedia.put("buồn", "sad");
        mapMedia.put("buồn_đời", "sad");
        mapMedia.put("buồn_tủi", "sad");
        mapMedia.put("tuyệt_vọng", "sad");
        mapMedia.put("vui_vẻ","happy");
        mapMedia.put("vui_sướng","happy");
        mapMedia.put("thoải_mái","happy");
        mapMedia.put("vui","happy");

        mediaType = Collections.unmodifiableMap(mapMedia);
    }

    public static final Map<String, String> feelMapIcon = new HashMap<>();

    static {
        feelMapIcon.put("đói_bụng", "ab:x");
        feelMapIcon.put("đói", "ab:x");
        feelMapIcon.put("bị_đá", "d:e");
        feelMapIcon.put("thất_tình", "b:e");
        feelMapIcon.put("đa_tình", "f:g:y");
        feelMapIcon.put("thiếu_thốn_tình_cảm", "p:t");
        feelMapIcon.put("buồn_ngủ", "m");
        feelMapIcon.put("mỏi_mắt", "m");
        feelMapIcon.put("điểm_kém", "b");
        feelMapIcon.put("điểm_thấp", "b");
        feelMapIcon.put("thi_tạch", "b");
        feelMapIcon.put("thi_rớt", "b");
        feelMapIcon.put("no_bụng", "i");
        feelMapIcon.put("no_bụng", "i");
        feelMapIcon.put("no", "i");
        feelMapIcon.put("bình_thường", "x");

        feelMapIcon.put("thoải_mái", "h:i");
        feelMapIcon.put("nhẹ_nhàng", "c");
        feelMapIcon.put("vui", "ac:f");
        feelMapIcon.put("vui_vẻ", "ac:f:s:w");
        feelMapIcon.put("vui_sướng", "ac:f:w");
        feelMapIcon.put("nhột", "i:y");
        feelMapIcon.put("nhồn_nhột", "ad:i:y");
        feelMapIcon.put("hồi_hộp", "k:t:y");
        feelMapIcon.put("tự_tin", "n:v:w");
        feelMapIcon.put("mạnh_mẽ", "d:l:v");
        feelMapIcon.put("tự_ti", "e");
        feelMapIcon.put("chán", "b");
        feelMapIcon.put("chán_đời", "a");
        feelMapIcon.put("chan_chán", "b");
        feelMapIcon.put("chán_nản", "b");
        feelMapIcon.put("buồn", "b:e");
        feelMapIcon.put("buồn_đời", "a:b");
        feelMapIcon.put("buồn_chán", "b:e");
        feelMapIcon.put("buồn_buồn", "b:e");
        feelMapIcon.put("buồn_tủi", "b:e");
        feelMapIcon.put("buồn_đau", "b");
        feelMapIcon.put("sợ", "b");
        feelMapIcon.put("sợ_hãi", "b");
        feelMapIcon.put("méo_biết", "j");
        feelMapIcon.put("đau", "b");
        feelMapIcon.put("đau_khổ", "b");
        feelMapIcon.put("đau_đớn", "b");
        feelMapIcon.put("tuyệt_vọng", "b");
        feelMapIcon.put("đau_buồn", "b");
        feelMapIcon.put("phẫn_nộ", "o");
        feelMapIcon.put("tức_giận", "j:o");
        feelMapIcon.put("bình_thường", "x");
    }
}
