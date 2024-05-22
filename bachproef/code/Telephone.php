<?php
namespace App\Controllers;
class Telephone extends BaseController
{
    public function index(): string
    {
        $session = session();
        $telephonemodel = model('TelephoneModel');
        $data['telephone'] = $telephonemodel->getByuser($session->get('id'));

        return view('dashboard', $data);
    }
}
