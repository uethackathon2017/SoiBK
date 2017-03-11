package soibk.hust.reactchat.network;

import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import soibk.hust.reactchat.model.Emotion;

/**
 * Created by nguyenbinh on 11/03/2017.
 */

public class APIUtils {
    public static Call<Emotion> getDetectEmotionAPI(String message) {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("http://10.10.215.51:8080")
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        DetectEmotionAPI service = retrofit.create(DetectEmotionAPI.class);
        return service.detectEmotion(message);
    }
}
