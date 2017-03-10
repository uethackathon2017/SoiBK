package com.soibk.hackathon;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import vn.hus.nlp.tokenizer.VietTokenizer;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

import java.io.IOException;

import static org.apache.http.HttpHeaders.USER_AGENT;


/**
 * Created by hieuapp on 10/03/2017.
 */

@Path("upload")
public class TextProcessor {

    private final String LUA_URL = "http://10.10.215.60:18081/modelLua/data";

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED    )
    public String fragmentText(@FormParam("message") String message){
        String action = "";
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
            action = IOUtils.toString(response.getEntity().getContent());

            System.out.println("Action result : " + action);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return action;
    }

}
