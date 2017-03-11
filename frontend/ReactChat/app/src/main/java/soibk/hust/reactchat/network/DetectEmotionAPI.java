package soibk.hust.reactchat.network;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;
import soibk.hust.reactchat.model.Emotion;

/**
 * Created by nguyenbinh on 11/03/2017.
 */

public interface DetectEmotionAPI {
    @FormUrlEncoded
    @POST("context/api/upload")
    Call<Emotion> detectEmotion(@Field("message") String message);
}
