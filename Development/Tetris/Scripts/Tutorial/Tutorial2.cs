using System;
using UnityEngine;
 
public class Tutorial2 : ITutorialTask
{
    public string GetTitle()
    {
        return "生成されるブロック";
    }
 
    public string GetText()
    {
        return "敵は毎ターンどこかに生まれます。" + Environment.NewLine + "また毎ターン１強くなります。";
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
