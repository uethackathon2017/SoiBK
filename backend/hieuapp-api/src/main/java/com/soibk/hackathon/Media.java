package com.soibk.hackathon;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Created by hieuapp on 11/03/2017.
 */

@XmlRootElement
public class Media {

    private String label;

    private String type;

    private String icon;

    private String music;

    private String wallpaper;

    private String product;

    private String story;

    public Media() {
    }

    public String getLabel() {
        return label;
    }

    public String getType() {
        return type;
    }

    public String getIcon() {
        return icon;
    }

    public String getMusic() {
        return music;
    }

    public String getWallpaper() {
        return wallpaper;
    }

    public String getProduct() {
        return product;
    }

    public String getStory() {
        return story;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public void setMusic(String music) {
        this.music = music;
    }

    public void setWallpaper(String wallpaper) {
        this.wallpaper = wallpaper;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public void setStory(String story) {
        this.story = story;
    }
}
