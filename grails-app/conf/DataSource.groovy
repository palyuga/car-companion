dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
            url = "jdbc:h2:mem:devDb;MVCC=TRUE;LOCK_TIMEOUT=10000"
//            driverClassName = "org.apache.derby.jdbc.ClientDriver"
//            dbCreate = "update"
//            url = "jdbc:derby://172.30.207.79:1527/sharecar"
//            username = "rs"
//            password = "rs"
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb;MVCC=TRUE;LOCK_TIMEOUT=10000"
        }
    }
    production {
        dataSource {
            driverClassName = "org.apache.derby.jdbc.ClientDriver"
            dbCreate = "update"
            url = "jdbc:derby://172.30.207.79:1527/sharecar"
            username = "rs"
            password = "rs"
            pooled = true
            properties {
               maxActive = -1
               minEvictableIdleTimeMillis=1800000
               timeBetweenEvictionRunsMillis=1800000
               numTestsPerEvictionRun=3
               testOnBorrow=true
               testWhileIdle=true
               testOnReturn=true
               validationQuery="select * from office fetch first row only"
            }
        }
    }
}
