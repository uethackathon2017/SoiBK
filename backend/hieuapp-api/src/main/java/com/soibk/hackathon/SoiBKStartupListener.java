package com.soibk.hackathon;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.inject.Singleton;

/**
 * Created by hieuapp on 10/03/2017.
 */

@Singleton
public class SoiBKStartupListener {

    @PostConstruct
    public void init() {
        // Perform action during application's startup
        System.out.print("dang khoi dong...");
    }

    @PreDestroy
    public void destroy() {
        // Perform action during application's shutdown
    }
}
