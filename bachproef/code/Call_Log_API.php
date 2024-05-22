<?php

namespace App\Controllers;

use App\Controllers\BaseController;

class CallLogs_API extends BaseController
{
    public function index($number = null)
    {
        $callModel = model('CallModel');
        $logs = $callModel->getLogsByTelephoneId($number, true);
        $logUsage = $this->calculateLogsUsage($logs);

        // Prepare JSON response
        $response = [
            'status' => 'success',
            'logs' => $logs,
            'totalMinutes' => $logUsage['totalMinutes'],
            'totalMessages' => $logUsage['totalMessages'],
            'totalData' => $logUsage['totalData']
        ];

        // Set content type header to application/json
        $this->response->setContentType('application/json');

        // Return JSON response
        return $this->response->setJSON($response);
    }

    private function calculateLogsUsage($logs)
    {
        $data = [
            'totalMinutes' => 0,
            'totalMessages' => 0,
            'totalData' => 0
        ];

        foreach ($logs as $key => $log) {
            if ($log['call_type'] == 'call') {
                $data['totalMinutes'] += $log['duration'];
            } else if ($log['call_type'] == 'sms') {
                $data['totalMessages'] += $log['duration'];
            } else if ($log['call_type'] == 'data') {
                $data['totalData'] += $log['duration'];
            }
        }
        return $data;
    }
}
