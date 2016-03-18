# Mysql Traversable Tree #
This is library containing procedures for easy recount traversable tree by parents realized by constraints in InnoDb. 
Procedures evaluate left and right sides of leaves. 

- Multi Tree is supported
- Automatically recounts traversable tree inside transaction

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
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  `_left` int(10) unsigned DEFAULT NULL,
  `_right` int(10) unsigned DEFAULT NULL,
  `_nesting` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_test_traversable_id_parent` (`id_parent`),
  CONSTRAINT `fk_test_traversable_id_parent` FOREIGN KEY (`id_parent`) REFERENCES `test_traversable` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Result ##
|           |          |       |        |          | 
|-----------|----------|-------|--------|----------| 
| id_parent | position | _left | _right | _nesting | 
|           | 1        | 5     | 16     | 0        | 
| 1         | 0        | 6     | 7      | 1        | 
| 1         | 0        | 8     | 9      | 1        | 
| 1         | 0        | 10    | 15     | 1        | 
| 4         | 0        | 11    | 12     | 2        | 
| 4         | 0        | 13    | 14     | 2        | 
|           | 0        | 1     | 4      | 0        | 
| 7         | 0        | 2     | 3      | 1        | 
