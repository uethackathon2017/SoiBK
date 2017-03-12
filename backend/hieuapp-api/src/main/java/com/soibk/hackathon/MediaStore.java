package com.soibk.hackathon;


import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by hieuapp on 11/03/2017.
 */
public class MediaStore {

    public static final String[]  sadMusic = new String[]{
            "http://zmp3-mp3-s1.zmp3-fpthn-1.za.zdn.vn/fce727d92e9dc7c39e8c/260328184917265066?key=PeyhFnZs-FhJe2YerGRe3A&expires=1489298221",
            "http://zmp3-mp3-s1.zmp3-fpthn-1.za.zdn.vn/29a658545610bf4ee601/8460808840116898754?key=Dn0CtRj6iv6JLHMfCXcB2Q&expires=1489298221",
            "http://zmp3-mp3-s1.zmp3-fpthn-1.za.zdn.vn/46855bfc28b8c1e698a9/1317241040606810461?key=0-Ulx8yxiOXW6doTNDt15Q&expires=1489299285"
    };

    public static final String[] relaxMusic = new String[]{
        "http://zmp3-mp3-s1.zmp3-fpthn-2.za.zdn.vn/d41230d1df9536cb6f84/1181817601640857205?key=LRCPfqDc-jpUE192xg8oOg&expires=1489296372",
        "http://zmp3-mp3-s1.zmp3-fpthn-1.za.zdn.vn/17e7fd5065148c4ad505/2876288742595448952?key=yNc5TrlhvkBlpIxEoWjE0g&expires=1489299414",
        "http://zmp3-mp3-s1.zmp3-fpthn-2.za.zdn.vn/e580018f98cb719528da/477681259769721395?key=gHSoBnDjSmWKt87TrYFQww&expires=1489298684"
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

            "http://androidwalls.net/wp-content/uploads/2014/07/Macro Water Drops Dark Blue Grass Android Wallpaper.jpg"

    };

    public static final String[] happyWall = new String[]{
            "http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/20120423225615782.jpg",

            "http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/Beautiful-Android-cell-phone-wallpapers-480x854-06.jpg",

            "http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/flash_jg42.jpg",

            "http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/high-definition-mobile-phone-wallpapers-720x1280-hd-pink-aura-610x1084.jpg",

            "http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/phone-5-wallpapers-0003-610x1082.jpg",

            "http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/windows-phone-480x800-wallpaper-01.jpg",

            "http://androidwalls.net/wp-content/uploads/2016/08/Pikachu Pokemon Go Character Minimal Android Wallpaper.jpg",

            "http://androidwalls.net/wp-content/uploads/2016/08/Funny Banana Lets Get Naked Android Wallpaper.jpg",

            "http://androidwalls.net/wp-content/uploads/2016/03/Green Blue Gradient Android Wallpaper.jpg",

            "http://androidwalls.net/wp-content/uploads/2016/03/Purple Pink Gradient Simple Android Wallpaper.jpg"
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
        feelMapIcon.put("bị_đá", "ac:d:e");
        feelMapIcon.put("thất_tình", "ac:b:e");
        feelMapIcon.put("đa_tình", "f:g:y");
        feelMapIcon.put("thiếu_thốn_tình_cảm", "p:t");
        feelMapIcon.put("buồn_ngủ", "m");
        feelMapIcon.put("mỏi_mắt", "m");
        feelMapIcon.put("mệt_mỏi", "m");
        feelMapIcon.put("mệt", "m");
        feelMapIcon.put("điểm_kém", "b");
        feelMapIcon.put("điểm_thấp", "b");
        feelMapIcon.put("thi_tạch", "b");
        feelMapIcon.put("tạch", "b");
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
        feelMapIcon.put("sướng", "ac:f:w");
        feelMapIcon.put("phê", "ac:f:w");
        feelMapIcon.put("nhột", "i:y");
        feelMapIcon.put("nhồn_nhột", "ad:i:y");
        feelMapIcon.put("hồi_hộp", "k:t:y");
        feelMapIcon.put("yêu", "k:t:y");
        feelMapIcon.put("tự_tin", "n:v:w");
        feelMapIcon.put("mạnh_mẽ", "d:l:v");
        feelMapIcon.put("tự_ti", "e");
        feelMapIcon.put("chán", "b");
        feelMapIcon.put("chán_đời", "a");
        feelMapIcon.put("bất_cần", "a");
        feelMapIcon.put("chan_chán", "b");
        feelMapIcon.put("chán_nản", "b");
        feelMapIcon.put("buồn", "ac:b:e");
        feelMapIcon.put("buồn_đời", "ac:a:b");
        feelMapIcon.put("buồn_chán", "ac:b:e");
        feelMapIcon.put("buồn_buồn", "ac:b:e");
        feelMapIcon.put("buồn_tủi", "ac:b:e");
        feelMapIcon.put("buồn_đau", "ac:b");
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
        feelMapIcon.put("bực", "j:o");
        feelMapIcon.put("bực_mình", "j:o");
        feelMapIcon.put("cay", "j:o");
        feelMapIcon.put("acay", "j:o");
        feelMapIcon.put("cay_cú", "j:o");
        feelMapIcon.put("cay_đắng", "j:o");
        feelMapIcon.put("đắng_lòng", "z");
        feelMapIcon.put("khó_chịu", "j:o");
        feelMapIcon.put("bình_thường", "x");
        feelMapIcon.put("không_cảm_xúc", "x");
        feelMapIcon.put("cô_đơn", "p");
        feelMapIcon.put("lạc_lõng", "p");
    }

    public static final Map<String, String[] > mapProduct = new HashMap<>();
    static {
        String[] tutor = new String[]{
                "Bạn muốn học tốt?",
                "Tìm gia sư kèm ngay.",
                "https://www.google.com.vn/search?q=gia+s%C6%B0"
        };
        mapProduct.put("điểm_kém", tutor);
        mapProduct.put("thi_rớt", tutor);
        mapProduct.put("thi_tạch", tutor);
        mapProduct.put("tạch", tutor);

        String[] fLove = new String[]{
                "Bạn muốn hẹn hò?",
                "Đăng ký tham gia ngay",
                "http://bit.ly/2aebgGZ"
        };
        mapProduct.put("thiếu_thốn_tình_cảm", fLove);
        mapProduct.put("thất_tình", fLove);
        mapProduct.put("bị_đá", fLove);

        String[] hungry = new String[]{
                "Bạn đang đói bụng?",
                "Foody ngay thôi",
                "https://www.foody.vn/"
        };
        mapProduct.put("đói_bụng", hungry);
        mapProduct.put("đói", hungry);

        String[] hurt = new String[]{
                "Bạn đang bị đau",
                "Tìm thuốc giảm đau ngay",
                "https://www.google.com.vn/search?q=thuốc+giảm+đau"
        };
        mapProduct.put("đau_mắt", hurt);
        mapProduct.put("đau_chân", hurt);
        mapProduct.put("đau_bụng", hurt);
        mapProduct.put("đau_đầu", hurt);
        mapProduct.put("đau_răng", hurt);
    }
}
