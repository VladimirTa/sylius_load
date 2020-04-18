<?php

    require_once './libs/mysql.php';
    require_once './libs/image.php';


    $shortopts  = "";
    $shortopts .= "d:";  // Обязательное значение
//    $shortopts .= "v::"; // Необязательное значение
//    $shortopts .= "abc"; // Эти параметры не принимают никаких значений

    $longopts  = array(
	"required:",     // Обязательное значение
//	"optional::",    // Необязательное значение
//	"option",        // Нет значения
//	"opt",           // Нет значения
    );
    $options = getopt($shortopts, $longopts);

    if(!isset($options['d']))
    {
	echo "укажите -d <база данных>\n";
	return;
    }

    $database=$options['d'];

    $opts = array(
        'user'    => 'root',
        'pass'    => 'GkMDk6br',
        'db'      => $database,
        'host'  => '192.168.1.37'
    );

    $db = new SafeMySQL($opts); // with some of the default settings overwritten
    $data = $db->getAll("SELECT p.id,t.id as picture_id,image as picture  FROM photo p left join tovar t on t.articule=p.articule;");

    foreach($data as $row)
    {
        $handle = fopen('/home/volodya/sylius_images/'.$database.'-'.$row['picture_id'].'-'.$row['id'].'-orig.jpg', 'wb');
        fwrite($handle, $row['picture']);
        fclose($handle);

       $image = new SimpleImage();
       $image->load('/home/volodya/sylius_images/'.$database.'-'.$row['picture_id'].'-'.$row['id'].'-orig.jpg');
       $image->resize_min(800,800);
       $image->save('/home/volodya/sylius_images/'.$database.'-'.$row['picture_id'].'-'.$row['id'].'.jpg');
	echo 'compliet '.'/home/volodya/sylius_images/'.$database.'-'.$row['picture_id'].'-'.$row['id'].'.jpg'."\r\n";
    }

?>