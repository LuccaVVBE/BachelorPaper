<?php


namespace App\Models;

use CodeIgniter\Model;

class UserModel extends Model
{
    protected $table = 'user';
    protected $primaryKey = 'id';

    function login($username, $password)
    {        
        $query = $this->query("SELECT * FROM user WHERE username = '$username' AND password = '$password'");
        $response = $query->getResult();
        return $response;
    }
}