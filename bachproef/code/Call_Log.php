<?php
namespace App\Controllers;
class Call_Log extends BaseController
{
    public function index(): string
    {
        $session = session();
        $callmodel = model('CallModel');
        $logs = $callmodel->getLogsByTelephoneId($_GET['number'], true);
        $logUsage = $this->calculateLogsUsage($logs);

        return view('usage', ['callLogs' => $logs, 'totalMinutes' => $logUsage['totalMinutes'], 'totalMessages' => $logUsage['totalMessages'], 'totalData'=>$logUsage['totalData']]);
    }

    private function calculateLogsUsage($logs)
    {
        $data = [
            'totalMinutes' => 0,
            'totalMessages' => 0,
            'totalData' => 0
        ];

        foreach ($logs as $key=> $log) {
            if($log['call_type'] == 'call'){
                $data['totalMinutes'] += $log['duration'];
            } else if($log['call_type'] == 'sms'){
                $data['totalMessages'] += $log['duration'];
            } else if($log['call_type'] == 'data'){
                $data['totalData'] += $log['duration'];
            }
        }
        return $data;
    }
}
