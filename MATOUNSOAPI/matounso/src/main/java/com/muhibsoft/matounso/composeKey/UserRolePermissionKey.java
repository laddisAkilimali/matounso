package com.muhibsoft.matounso.composeKey;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Embeddable;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Embeddable
@NoArgsConstructor
public class UserRolePermissionKey implements Serializable {

    private Long idRole;
    private Long idPermission;

    public UserRolePermissionKey(Long idRole, Long idPermission) {
        this.idRole = idRole;
        this.idPermission = idPermission;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof UserRolePermissionKey))
            return false;

        UserRolePermissionKey that = (UserRolePermissionKey) o;

        return Objects.equals(getIdPermission(), that.getIdPermission())
                & Objects.equals(getIdRole(), that.getIdRole());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getIdPermission(), getIdRole());
    }

}
