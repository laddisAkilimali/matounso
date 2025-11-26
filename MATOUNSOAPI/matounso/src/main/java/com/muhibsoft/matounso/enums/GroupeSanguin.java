package com.muhibsoft.matounso.enums;

import lombok.Getter;

@Getter
public enum GroupeSanguin {
    A("A"),
    B("B"),
    AB("AB"),
    O("O"),
    PLUS("+"),
    MOINS("-");

    private final String symbole;

    GroupeSanguin(String symbole) {
        this.symbole = symbole;
    }
}
