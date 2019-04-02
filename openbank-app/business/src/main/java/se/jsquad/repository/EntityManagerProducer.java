package se.jsquad.repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

public class EntityManagerProducer {
    @PersistenceContext(unitName = "openBankPU")
    private EntityManager entityManager;

    public EntityManager getEntityManager() {
        return entityManager;
    }
}
