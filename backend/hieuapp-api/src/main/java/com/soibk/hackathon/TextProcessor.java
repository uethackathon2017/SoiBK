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
import java.net.URL;
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
        System.out.println(message);
        String processedResult = "";
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

        VietTokenizer vietTokenizer = SoiBKContextDeploy.getTokenizer();
        String result = vietTokenizer.tokenize(message)[0];

        HttpClient client = HttpClientBuilder.create().build();
        HttpPost post = new HttpPost(LUA_URL);

        // add header
        post.setHeader("User-Agent", USER_AGENT);
        post.setEntity(new StringEntity(result, "utf-8"));

        HttpResponse response = null;
        try {
            response = client.execute(post);
            processedResult = IOUtils.toString(response.getEntity().getContent());

            System.out.println("Action result : " + processedResult);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Media media;

        try{
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

    private Media getResponseMedia(String state){

        String emotions = MediaStore.feelMapIcon.get(state);
        if(emotions == null){
            Media media = new Media();
            media.setLabel(state);
            media.setIcon(MediaStore.feelMapIcon.get(DEFAULT_VALUE));

            return media;
        }

        String[] args = emotions.split(":");

        Random random = new Random();
        int range = args.length +1;
        int index = random.nextInt(range);

        String emotion = args[index];
        String music = "";
        String wall = "";


        String mediaType = MediaStore.mediaType.get(state);
        if(mediaType != null){
            if(mediaType.equals("sad")){
                music = MediaStore.sadMusic[index];
                wall = MediaStore.sadWall[index];
            }else {
                music = MediaStore.relaxMusic[index];
                wall = MediaStore.happyWall[index];
            }
        }

        Media media = new Media();
        media.setLabel(state);
        media.setIcon(emotion);
        try {
            media.setMusic(URLEncoder.encode(music,"utf-8"));
            media.setWallpaper(URLEncoder.encode(wall, "utf-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        System.out.println(media.toString());
        return media;
    }

}
