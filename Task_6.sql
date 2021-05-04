
-- Задание 1
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type ENUM('messages', 'users', 'posts', 'media') NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS target_types;
CREATE TEMPORARY TABLE target_types (
  name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');


INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    (SELECT name FROM target_types ORDER BY RAND() LIMIT 1),
    CURRENT_TIMESTAMP 
  FROM messages;


SELECT * FROM posts p LIMIT 100;


DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Задание 2
show tables;

desc profiles;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);
   
 ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);
   
ALTER TABLE communities_users 
  ADD CONSTRAINT community_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id);
   
ALTER TABLE media 
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD constraint media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
   
ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD constraint posts_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD constraint posts_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id);
   
ALTER TABLE friendship 
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD constraint friendship_friendship_status_id_fk 
    FOREIGN KEY (friendship_status_id) REFERENCES friendship_statuses(id);
   
ALTER TABLE likes 
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);
   
   
-- Задание 3
   
   COUNT(*) as total from likes where user_id in (SELECT user_id FROM profiles where gender = 'f');
  
 SELECT sex FROM (
	SELECT "m" as sex, COUNT(*) as total FROM likes WHERE user_id IN (SELECT user_id FROM profiles where gender = 'm')
	UNION
	SELECT "f" as sex, COUNT(*) as total FROM likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender = 'f')
) as my_sort
ORDER BY total DESC
LIMIT 1;

-- Задание 4
  
SELECT 
  CONCAT(first_name, ' ', last_name) AS user,
  (SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS total_messages,
  (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id) AS total_posts,  
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) AS total_media, 
	(SELECT COUNT(*) AS likes FROM media m GROUP BY user_id) 
	  FROM users;
      

