package com.soibk.hackathon;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.json.JSONException;
import org.json.JSONObject;
import vn.hus.nlp.tokenizer.VietTokenizer;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Random;

import static org.apache.http.HttpHeaders.USER_AGENT;


/**
 * Created by hieuapp on 10/03/2017.
 */

@Path("upload")
public class TextProcessor {

    private final String LUA_URL = "http://10.10.215.60:18081/modelLua/data";

    private final String DEFAULT_VALUE = "bình_thường";

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED    )
    public Media fragmentText(@FormParam("message") String message){
        System.out.println("receiver message: " + message);

//        Runtime rt = Runtime.getRuntime();
//        Process pr;
//        try {
//            pr = rt.exec("pwd");
//            BufferedReader input = new BufferedReader(new InputStreamReader(pr.getInputStream()));
//            String line = null;
//
//            try {
//                while ((line = input.readLine()) != null)
//                    System.out.println(line);
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//
//        } catch (IOException e) {
//            e.printStackTrace();
//        }

        /**
         * Natural Language Processing
         */
        String processedResult = "";
//
//        VietTokenizer vietTokenizer = SoiBKContextDeploy.getTokenizer();
//        String result = vietTokenizer.tokenize(message)[0];
//
//        HttpClient client = HttpClientBuilder.create().build();
//        HttpPost post = new HttpPost(LUA_URL);
//
//        // add header
//        post.setHeader("User-Agent", USER_AGENT);
//        post.setEntity(new StringEntity(result, "utf-8"));
//
//        HttpResponse response = null;
//        try {
//            response = client.execute(post);
//            processedResult = IOUtils.toString(response.getEntity().getContent());
//
//            System.out.println("Action result : " + processedResult);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }

        /**
         * Response result text parse for mobile
         */
        Media media;

        try{
            if(ConfigApp.DEBUG){
                JSONObject stateResult = new JSONObject();
                stateResult.put("state", DEFAULT_VALUE);
                stateResult.put("feel", message);
                processedResult = stateResult.toString();
            }

            JSONObject jsonObject = new JSONObject(processedResult);
            String state = jsonObject.getString("state");
            String feel = jsonObject.getString("feel");

            if(!feel.equals(DEFAULT_VALUE)){
                media = getResponseMedia(feel);
                return media;
            }

            if(!state.equals(DEFAULT_VALUE)){
                media = getResponseMedia(state);
                return media;
            }else {
                media = new Media();
                media.setLabel(DEFAULT_VALUE);
                media.setIcon(MediaStore.feelMapIcon.get(DEFAULT_VALUE));
                return media;
            }
        }catch (JSONException e){
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get medial for state
     * @param state
     * @return
     */
    private Media getResponseMedia(String state){

        String emotions = MediaStore.feelMapIcon.get(state);
        if(emotions == null){
            return getDefaultMedia(state);
        }

        String[] args = emotions.split(":");

        int index = getRandomItem(args.length - 1);

        String emotion = args[index];

        Media media = new Media();
        media.setLabel(state);
        media.setIcon(emotion);

        String mediaType = MediaStore.mediaType.get(state);
        if(mediaType != null){
            String musicURL = "";
            String wallURL = "";

            if(mediaType.equals("sad")){
                int mIndex = getRandomItem(MediaStore.sadMusic.length -1);
                musicURL = MediaStore.sadMusic[mIndex];
                int wIndex = getRandomItem(MediaStore.sadWall.length - 1);
                wallURL = MediaStore.sadWall[wIndex];

            }else {
                int mIndex = getRandomItem(MediaStore.relaxMusic.length -1);
                musicURL = MediaStore.relaxMusic[mIndex];
                int wIndex = getRandomItem(MediaStore.happyWall.length - 1);
                wallURL = MediaStore.happyWall[wIndex];
            }

            media.setMusic(musicURL);
            media.setWallpaper(wallURL);

        }

        System.out.println("music url = " +media.getMusic());
        System.out.println("wall url = " +media.getWallpaper());

        return media;
    }

    private Media getDefaultMedia(String state) {
        Media media = new Media();
        media.setLabel(state);
        media.setIcon(MediaStore.feelMapIcon.get(DEFAULT_VALUE));

        return media;
    }

    private int getRandomItem(int max){
        Random random = new Random();
        return random.nextInt(max + 1);
    }

    private String encodeURL(String url) throws UnsupportedEncodingException {
        if(url.equals("") || url == null){
            return "";
        }

        int lastSec = url.lastIndexOf("/");
        String firstPart = url.substring(0, lastSec);
        String lastPart = url.substring(lastSec + 1);

        String lastPartEncoded = URLEncoder.encode(lastPart, "utf-8");

        return firstPart + "/" + lastPartEncoded;
    }
}
