package com.muhibsoft.matounso.composeKey;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Embeddable;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Embeddable
@NoArgsConstructor
public class UserRoleKey implements Serializable {
    private Long idUser;
    private Long idRole;

    public UserRoleKey(Long idUser, Long idRole) {
        this.idUser = idUser;
        this.idRole = idRole;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof UserRoleKey))
            return false;
        UserRoleKey that = (UserRoleKey) o;

        return Objects.equals(getIdUser(), that.getIdUser()) &&
                Objects.equals(getIdRole(), that.getIdRole());

    }

    @Override
    public int hashCode() {
        return Objects.hash(getIdUser(), getIdRole());
    }
}
