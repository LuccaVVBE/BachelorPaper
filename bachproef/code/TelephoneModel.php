<?php
namespace App\Models;

use CodeIgniter\Model;


class TelephoneModel extends Model
{
    protected $table = 'telephone_number';
    protected $primaryKey = 'id';
    
    function getByuser($userid)
    {
        $query = $this->query("SELECT * FROM telephone_number WHERE user_id = '$userid'");
        $response = $query->getResult();
        return $response;
    }
}