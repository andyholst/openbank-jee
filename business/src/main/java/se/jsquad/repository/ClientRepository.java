package se.jsquad.repository;

import se.jsquad.Account;
import se.jsquad.Client;
import se.jsquad.qualifier.Log;

import javax.inject.Inject;
import javax.persistence.TypedQuery;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClientRepository extends EntityManagerProducer {
    @Inject @Log
    private Logger logger;

    public Client getClientByPersonIdentification(String personIdentification) {
        logger.log(Level.FINE, "getClientByPersonIdentification(personIdentification: {0})",
                new Object[] {"hidden"});

        TypedQuery<Client> query = getEntityManager().createNamedQuery(Client.PERSON_IDENTIFICATION,
                Client.class);
        query.setParameter(Client.PARAM_PERSON_IDENTIFICATION, personIdentification);

        List<Client> clientList = query.getResultList();

        if (clientList == null || clientList.isEmpty()) {
            return null;
        } else {
            return clientList.get(0);
        }
    }

    public Account getAccountByNumber(String accountNumber) {
        logger.log(Level.FINE, "getAccountByNumber(accountNumber: {0})", accountNumber);

        TypedQuery<Account> query = getEntityManager().createNamedQuery(Account.ACCOUNT_ID, Account.class);
        query.setParameter(Account.PARAM_ACCOUNT_NUMBER, accountNumber);

        List<Account> accountList = query.getResultList();

        if (accountList == null || accountList.isEmpty()) {
            return null;
        } else {
            return accountList.get(0);
        }
    }

    public void createClient(Client client) {
        logger.log(Level.FINE, "createClient(client: {0})",
                new Object[] {"hidden"});

        getEntityManager().persist(client);
    }
}