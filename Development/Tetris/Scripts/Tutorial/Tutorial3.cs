using System;
using UnityEngine;
 
public class Tutorial3 : ITutorialTask
{
    public string GetTitle()
    {
        return "ハイスコアを目指そう！";
    }
 
    public string GetText()
    {
        return "" + Environment.NewLine + "";
    }
 
    public void OnTaskSetting()
    {
    }
 
    public bool CheckTask()
    {
        if (Input.GetKey(KeyCode.Space)) {
            return true;
        }
 
        return false;
    }
 
    public float GetTransitionTime()
    {
        return 0.1f;
    }
}
