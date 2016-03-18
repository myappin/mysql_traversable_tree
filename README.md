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
| id | id_parent | _left | _right | _nesting | 
|----|-----------|-------|--------|----------| 
| 1  |           | 0     | 11     | 0        | 
| 2  | 1         | 1     | 2      | 1        | 
| 3  | 1         | 3     | 4      | 1        | 
| 4  | 1         | 5     | 10     | 1        | 
| 5  | 4         | 6     | 7      | 2        | 
| 6  | 4         | 8     | 9      | 2        | 
| 7  |           | 14    | 17     | 0        | 
| 8  | 7         | 15    | 16     | 1        | 
