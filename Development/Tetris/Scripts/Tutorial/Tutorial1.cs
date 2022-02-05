using UnityEngine;
 
public class Tutorial1 : ITutorialTask
{
    public string GetTitle()
    {
        return "約数を取ろう！";
    }
 
    public string GetText()
    {
        return "プレイヤーは自身の１以外の約数のブロックを吸収することができます。";
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