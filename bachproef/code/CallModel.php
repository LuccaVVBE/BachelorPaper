<?php

namespace App\Models;

use CodeIgniter\Model;

class CallModel extends Model
{
    protected $table = 'call_log';
    protected $primaryKey = 'id';
    protected $allowedFields = ['telephone_id', 'call_date', 'call_time', 'duration', 'call_type', 'call_number', 'call_cost'];

    public function getLogsByTelephoneId($telephone_id, $this_month = false)
    {
        if ($this_month) {
            $date = date('Y-m-01');
            $this->where('call_date >=', $date);
        }
        //order desc
        $this->orderBy('call_date', 'DESC');
        return $this->where('telephone_number_id', $telephone_id)->findAll();
    }
}