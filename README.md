# Mysql Traversable Tree #
- Multi Tree is supported
- Automatically recount traversable tree inside transaction

## Traversing ##
is fully dependent on parent element (id_parent). 

## Calling ##
```sql
CALL UpdateTraversable('TableName');
```

This can be called manually or by event after table change (Event Scheduler).

## Prepare table ##
```sql
CREATE TABLE `test_traversable` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_parent` int(10) unsigned DEFAULT NULL,
  `_left` int(10) unsigned DEFAULT NULL,
  `_right` int(10) unsigned DEFAULT NULL,
  `_nesting` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_test_traversable_id_parent` (`id_parent`),
  CONSTRAINT `fk_test_traversable_id_parent` FOREIGN KEY (`id_parent`) REFERENCES `test_traversable` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
