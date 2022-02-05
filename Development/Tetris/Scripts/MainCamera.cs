using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCamera : MonoBehaviour
{
    public float defaultWidth = 1125.0f;
 
    //最初に作った画面のheight
    public float defaultHeight = 2436.0f;
    // Start is called before the first frame update
    void Start()
    {
        this.transform.localPosition = new Vector3(GameSystem.defaultPlayerX*1.0f,10.0f,GameSystem.defaultPlayerY*1.0f);
         Camera mainCamera = Camera.main;
 
        //最初に作った画面のアスペクト比 
        float defaultAspect = defaultWidth / defaultHeight;
 
        //実際の画面のアスペクト比
        float actualAspect = (float)Screen.width / (float)Screen.height;
 
        //実機とunity画面の比率
        float ratio = actualAspect / defaultAspect;
 
        //サイズ調整
        mainCamera.orthographicSize /= ratio;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
