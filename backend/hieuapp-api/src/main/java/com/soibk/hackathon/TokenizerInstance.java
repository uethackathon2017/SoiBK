package com.soibk.hackathon;

import vn.hus.nlp.tokenizer.VietTokenizer;

/**
 * Created by hieuapp on 10/03/2017.
 */
public class TokenizerInstance {

    private static VietTokenizer tokenizer = null;

    public TokenizerInstance(){
    }

    public static String getTokenizer(String ss){
        if(tokenizer == null){
            tokenizer = new VietTokenizer();
        }

        return tokenizer.tokenize(ss)[0];
    }
}
