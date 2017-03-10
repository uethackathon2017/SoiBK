package com.soibk.hackathon;

import com.sun.org.glassfish.gmbal.ParameterNames;

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
    @Produces(MediaType.TEXT_PLAIN)
    @Path("/{message}")
    public void fragmentText(@PathParam("message") String message){
        System.out.print(message);
    }

}
