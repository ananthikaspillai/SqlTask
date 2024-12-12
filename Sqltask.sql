--1
CREATE TABLE userValue (
	id SERIAL PRIMARY KEY,
	email VARCHAR(30) NOT NULL UNIQUE,
	name VARCHAR(30) NOT NULL
);

CREATE TABLE collections (
	collection_id SERIAL PRIMARY KEY,
	collection_name VARCHAR(30) NOT NULL UNIQUE,
	owner_id INT references userValue(id) NOT NULL
);

CREATE TABLE bookmarks (
	bookmark_id SERIAL PRIMARY KEY,
	collection_id INT references collections(collection_id),
	bookmark_title VARCHAR(30) NOT NULL,
	bookmark_url VARCHAR(100) NOT NULL UNIQUE,
	bookmark_owner_id INT references userValue(id),
	bookmark_date DATE NOT NULL
);

CREATE TABLE tags (
	tag_id SERIAL PRIMARY KEY,
	tag_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE tagsbookmark (
	bookmark_tag_id SERIAL PRIMARY KEY,
	bookmark_id INT references bookmarks(bookmark_id) NOT NULL,
	tag_id INT references tags(tag_id) NOT NULL
);

CREATE TABLE shares (
	share_id SERIAL PRIMARY KEY,
	collection_id INT references collections(collection_id) NOT NULL,
	shared_with_id INT references userValue(id) NOT NULL,
	share_date date NOT NULL
);

--2

INSERT INTO userValue values
	(DEFAULT, 'anu@gamil.com', 'Ananthika'),
	(DEFAULT, 'ammu@gamil.com', 'Ammu'),
	(DEFAULT, 'anjuk@gamil.com', 'Anju');

INSERT INTO tags values
	(DEFAULT, 'bookmark1'),
	(DEFAULT, 'Bookmark2'),
 	(DEFAULT, 'bookmark3'),
	(DEFAULT, 'bookmark4');
	

INSERT INTO collections values
  	(DEFAULT, 'Development ', 1),
  	(DEFAULT, 'Values', 2);

INSERT INTO bookmarks values
  	(DEFAULT, 1, 'value1', 'https://react1.com', 1, '10-10-2022'),
  	(DEFAULT, 1, 'value2', 'https://java1.com', 3, '11-11-2013'),
  	(DEFAULT, 1, 'value3', 'https://nextjs.com', 1, '13-11-2014'),
  	(DEFAULT, 1, 'value3', 'https://react2.com', 3, '14-10-2015'),
  	(DEFAULT, 2, 'value4', 'https://next2.com', 1, '21-11-2015');

INSERT INTO tagsbookmark values
	(DEFAULT, 1, 1),
	(DEFAULT, 2, 2),
  	(DEFAULT, 3, 1),
  	(DEFAULT, 4, 2),
	(DEFAULT, 5, 3);

INSERT INTO shares values
	(DEFAULT, 1, 2, '11-12-2024'),
	(DEFAULT, 1, 3, '12-12-2024'),
	(DEFAULT, 2, 1, '12-12-2024'),
	(DEFAULT, 2, 3, '13-12-2024');

SELECT b.bookmark_title,
	b.bookmark_url,
	t.tag_name
FROM bookmarks b
INNER JOIN collections c
	ON c.collection_id = b.collection_id
INNER JOIN tagsbookmark bt
	ON bt.bookmark_id = b.bookmark_id
INNER JOIN tags t
	ON t.tag_id = bt.tag_id
WHERE c.collection_name = 'TDMS';



SELECT t.tag_name, COUNT(t.tag_id)
FROM tags t
INNER JOIN tagsbookmark bt
	ON bt.tag_id = t.tag_id
GROUP BY t.tag_name
ORDER BY COUNT(t.tag_id) DESC
LIMIT 10;


SELECT
	c.collection_name,
	u.email,
	COUNT(DISTINCT b.bookmark_id)
FROM collections c
INNER JOIN userValue u
	ON c.owner_id = u.id
INNER JOIN bookmarks b
	ON b.collection_id = c.collection_id
INNER JOIN shares s
	ON s.collection_id = c.collection_id
GROUP BY c.collection_name, u.email;



SELECT u.name
FROM userValue u
INNER JOIN bookmarks b
	ON b.bookmark_owner_id = u.id
LEFT JOIN shares s
	ON s.shared_with_id = u.id
WHERE s.share_date > current_date - interval '30 days'
OR b.bookmark_date > current_date - interval '30 days'
GROUP BY u.name
	