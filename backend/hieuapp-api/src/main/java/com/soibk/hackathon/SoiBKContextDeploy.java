package com.soibk.hackathon;

import vn.hus.nlp.tokenizer.VietTokenizer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Created by hieuapp on 10/03/2017.
 */
public class SoiBKContextDeploy implements ServletContextListener {

    private static VietTokenizer tokenizer = null;

    public static VietTokenizer getTokenizer(){
        if(tokenizer == null){
            tokenizer = new VietTokenizer();
        }

        return tokenizer;
    }

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        tokenizer = new VietTokenizer();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        tokenizer = null;
    }
}
