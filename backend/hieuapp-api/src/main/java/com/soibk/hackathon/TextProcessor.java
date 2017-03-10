package com.soibk.hackathon;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


/**
 * Created by hieuapp on 10/03/2017.
 */

@Path("upload")
public class TextProcessor {

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/{message}")
    public String fragmentText(@PathParam("message")String message){
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
        return TokenizerInstance.getTokenizer(message);
    }

}
